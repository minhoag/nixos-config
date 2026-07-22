{ host, pkgs, ... }:
{
  # these will be overlayed in nixpkgs automatically.
  # for example: environment.systemPackages = with pkgs; [pokego];
  hotkeyhub = pkgs.callPackage ./hotkeyhub.nix { };
  pokego = pkgs.callPackage ./pokego.nix { };
  unikey-wayland = pkgs.callPackage ./unikey-wayland.nix { };
  # waybar-weather = pkgs.callPackage ./waybar-weather.nix { };
  
}
