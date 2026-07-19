{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    inputs.sfdx-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
    obsidian
    # github-desktop
    pokego # Overlayed
   # waybar-weather # Waybar Weather Module
];
}
