{ inputs, ... }:
{
  imports = [
    ./dms
    ./swaylock
  ];

  programs.niri.enable = true;

  home-manager.sharedModules = [
    {
      imports = [ inputs.niri.homeModules.niri ];
      programs.niri.settings = { };
    }
  ];
}
