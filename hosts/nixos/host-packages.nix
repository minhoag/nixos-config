{ pkgs,  ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    # github-desktop
    pokego # Overlayed
   # waybar-weather # Waybar Weather Module
];
}
