{ pkgs, ... }:

{
  home-manager.sharedModules = [
    ({
      home.packages = [ termius ];
    })
  ];
}
