{ pkgs, ... }:
{
  imports = [ ./opencode.nix ];

  environment.systemPackages = with pkgs; [
    nodejs
    opencode
  ];

  home-manager.sharedModules = [
    {
      xdg.configFile = {
        "opencode/command".source = ./commands;
        "opencode/plugin".source = ./plugins;
        "opencode/.ponytail-active".source = ./.ponytail-active;
        "opencode/AGENTS.md".source = ./AGENTS.md;
      };
    }
  ];
}
