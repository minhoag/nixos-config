{
  host,
  pkgs,
  self,
  ...
}:
let
  inherit (import "${self}/hosts/${host}/variables.nix") username;
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = [ pkgs.vmk ];
      waylandFrontend = true;
    };
  };

  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", MODE="0660", GROUP="input"
    SUBSYSTEM=="input", KERNEL=="event*", MODE="0660", GROUP="input"
  '';

  systemd.services.vmk-uinput = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = username;
      Group = "input";
      ExecStart = "${pkgs.vmk}/libexec/fcitx5_uinput_server -u ${username}";
      Restart = "on-failure";
    };
  };

  home-manager.sharedModules = [
    {
      xdg.configFile."fcitx5/profile".text = ''
        [Groups/0]
        Name=Default
        Default Layout=us
        DefaultIM=vmk

        [Groups/0/Items/0]
        Name=keyboard-us
        Layout=

        [Groups/0/Items/1]
        Name=vmk
        Layout=

        [GroupOrder]
        0=Default
      '';
    }
  ];
}
