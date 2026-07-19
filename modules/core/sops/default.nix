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
          private_ssh_key = {
            path = "${config.home.homeDirectory}/.ssh/id_ed25519";
            mode = "0600";
          };

          rclone_gdrive_env = {
            path = "${config.home.homeDirectory}/.config/rclone/gdrive.env";
            mode = "0600";
          };

          git_email = { };
          git_key_id = { };
          gemini_api_key = { };
        };

        sops.templates.git-identity = lib.mkIf haveSecrets {
          content = ''
            [user]
              email = ${config.sops.placeholder.git_email}
              signingkey = ${config.sops.placeholder.git_key_id}
            [commit]
              gpgsign = true
            [tag]
              gpgsign = true
          '';
          mode = "0600";
        };

        programs.git = lib.mkIf haveSecrets {
          enable = true;
          includes = [
            { path = config.sops.templates.git-identity.path; }
          ];
        };

        programs.bash.initExtra = lib.mkIf haveSecrets (
          lib.mkAfter ''
            gemini() {
              env GEMINI_API_KEY="$(<${config.sops.secrets.gemini_api_key.path})" gemini "$@"
            }
          ''
        );

        programs.fish.functions.gemini = lib.mkIf haveSecrets {
          body = ''
            env GEMINI_API_KEY=(cat ${config.sops.secrets.gemini_api_key.path}) gemini $argv
          '';
        };
      }
    )
  ];
}
