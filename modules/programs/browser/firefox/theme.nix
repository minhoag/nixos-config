{ pkgs, ... }:
let
  modBlur = pkgs.fetchFromGitHub {
    owner = "datguypiko";
    repo = "Firefox-Mod-Blur";
    rev = "v2.64";
    hash = "sha256-ENVVA77CleGVX2UzhwZoNhpTnGh7WyMCPYtFdamomas=";
  };
in
{
  home-manager.sharedModules = [
    {
      programs.firefox.profiles.default = {
        settings."toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        userChrome = builtins.readFile "${modBlur}/userChrome.css";
        userContent = builtins.readFile "${modBlur}/userContent.css";
      };
    }
  ];
}
