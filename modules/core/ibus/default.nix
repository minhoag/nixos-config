{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = [ pkgs.unikey-wayland ];
  };
}
