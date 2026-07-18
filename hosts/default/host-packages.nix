{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    # proton-vpn
    # github-desktop
    pokego # Overlayed
    # waybar-weather # Waybar Weather Module
  ];
}
