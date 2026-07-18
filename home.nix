{ config, pkgs, ... }:

{
  home.username = "wumps";
  home.homeDirectory = "/home/wumps";
  home.stateVersion = "26.05";
  home.file.".local/share/Steam/steamapps".source =
    config.lib.file.mkOutOfStoreSymlink "/mnt/Games/SteamLibrary/steamapps";
  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.ghostty.enable = true;
  programs.neovim.enable = true;
  home.packages = with pkgs; [
    code-cursor
    nixfmt-rfc-style
    steam-run
    protonplus
  ];
}
