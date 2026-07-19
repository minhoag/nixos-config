{ ... }:

{
  home-manager.sharedModules = [
    ({ ... }: {
      imports = [
        ./gtk.nix
      ];
      features.themes.gtk.enable = true;
    })
  ];
}
