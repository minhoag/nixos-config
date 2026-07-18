{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.packages = [ inputs.phonto.packages.${pkgs.system}.phonto ];
    }
  ];
}
