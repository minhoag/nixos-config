{
  self,
  inputs,
  lib,
  ...
}:
let
  secretFile = "${self}/secrets/secrets.yaml";
  haveSecrets = builtins.pathExists secretFile;
in
{
  home-manager.sharedModules = [
    inputs.sops-nix.homeManagerModules.sops
    (
      { config, ... }:
      {
        sops = {
          age.generateKey = true;
          age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
          defaultSopsFile = secretFile;
          defaultSopsFormat = "yaml";
        };

        sops.secrets = lib.mkIf haveSecrets {
          vilao_api_key = { };
          sakana_api_key = { };
        };

        programs.bash.initExtra = lib.mkIf haveSecrets (
          lib.mkAfter ''
            opencode() {
              env VILAO_API_KEY="$(<${config.sops.secrets.vilao_api_key.path})" SAKANA_API_KEY="$(<${config.sops.secrets.sakana_api_key.path})" opencode "$@"
            }
          ''
        );

        programs.fish.functions.opencode = lib.mkIf haveSecrets {
          body = ''
            env VILAO_API_KEY=(cat ${config.sops.secrets.vilao_api_key.path}) SAKANA_API_KEY=(cat ${config.sops.secrets.sakana_api_key.path}) opencode $argv
          '';
        };
      }
    )
  ];
}
