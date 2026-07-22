{ inputs, pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = [
      (inputs.ibus-bamboo.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (_: {
        buildInputs = [ pkgs.libxtst ];
      }))
    ];
  };
}
