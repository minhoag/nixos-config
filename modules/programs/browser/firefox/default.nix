{
  self,
  inputs,
  lib,
  pkgs,
  config,
  ...
}: # Sourced config into root scope
{

  home-manager.sharedModules = [
    (_: {
      programs.firefox = {
        enable = true;
      };
    })
  ];
}
