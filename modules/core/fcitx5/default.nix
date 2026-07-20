{ inputs, ... }:
{
  imports = [ inputs.fcitx5-lotus.nixosModules.fcitx5-lotus ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
  };

  services.fcitx5-lotus = {
    enable = true;
    users = [ "wumps" ];
  };
}
