{ inputs, pkgs, ... }:
{
  imports = [
    ./dms
    ./swaylock
    ./cursor
  ];

  programs.niri.enable = true;

  # Niri uses this for on-demand X11 compatibility (Steam, Wine, etc.).
  environment.systemPackages = [ pkgs.xwayland-satellite ];

  home-manager.sharedModules = [
    {
      imports = [ inputs.niri.homeModules.niri ];
      programs.niri.settings = {
        overview.workspace-shadow.enable = false;
        hotkey-overlay.skip-at-startup = true;
      };
    }
  ];
}
