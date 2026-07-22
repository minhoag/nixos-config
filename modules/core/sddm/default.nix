{
  pkgs,
  inputs,
  ...
}:

let
  sddm-theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "samaritan";
    version = "unstable";
    src = inputs.samaritan-sddm-theme;
    installPhase = ''
        mkdir -p $out/share/sddm/themes/samaritan
        cp -r . $out/share/sddm/themes/samaritan
        cp ${./bg.jpg} $out/share/sddm/themes/samaritan/bg.jpg
        substituteInPlace $out/share/sddm/themes/samaritan/Main.qml \
          --replace-fail 'SAMARITAN v1.2.951.04' 'WUMPS' \
          --replace-fail 'text: "SAMARITAN"' 'text: "WUMPS"' \
          --replace-fail 'Rectangle {' 'Rectangle {
      Image {
          anchors.fill: parent
          source: "bg.jpg"
          fillMode: Image.PreserveAspectCrop
      }'
        substituteInPlace $out/share/sddm/themes/samaritan/components/PasswordField.qml \
          --replace-fail 'border.color: colors.background' 'border.color: "transparent"' \
          --replace-fail 'color: colors.background' 'color: "transparent"' \
          --replace-fail 'color: colors.primaryText' 'color: "#2B2418"'
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
        theme = "samaritan";
        settings.General.GreeterEnvironment = "QML_DISABLE_DISK_CACHE=1";
      };
    };
  };
}
