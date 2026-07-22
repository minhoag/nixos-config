{
  pkgs,
  inputs,
  ...
}:

let
  sddm-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "caelestia";
    version = "unstable";
    src = inputs.caelestia-sddm;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/caelestia
      cp -r themes/minimalistV2/. $out/share/sddm/themes/caelestia
    '';
  };
in
{
  imports = [
    ./icon.nix
  ];
  environment.systemPackages = [ sddm-theme ];
  qt.enable = true;
  services = {
    accounts-daemon.enable = true;
    displayManager = {
      generic.preStart = ''
        echo "Sleeping to wait for session registration..."
        sleep 1
      '';
      defaultSession = "hyprland-uwsm";
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
        theme = "caelestia";
        settings.General.GreeterEnvironment = "QML_DISABLE_DISK_CACHE=1";
      };
    };
  };
}
