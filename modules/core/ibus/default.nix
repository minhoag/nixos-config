{ inputs, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = [ inputs.ibus-bamboo.packages.${pkgs.system}.default ];
  };
}
