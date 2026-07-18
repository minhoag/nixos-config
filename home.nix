{ pkgs, ... }:

{
  home.username = "wumps";
  home.homeDirectory = "/home/wumps";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
programs.git.enable = true;
programs.ghostty.enable = true;
programs.neovim.enable = true;
home.packages = with pkgs; [
cursor
];
}
