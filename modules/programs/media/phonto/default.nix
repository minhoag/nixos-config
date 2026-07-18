{ inputs, ... }:
{
  home-manager.sharedModules = [
    ({ pkgs, ... }: {
      home.packages = [ inputs.phonto.packages.${pkgs.stdenv.hostPlatform.system}.phonto ];
    })
  ];
}
