{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.packages = [ pkgs.discord ];
    }
  ];
}
