{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.themes.gtk;
in
{
  options.features.themes.gtk.enable = mkEnableOption "gtk theme";
  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = "1";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = "1";
      };
    };
  };
}
