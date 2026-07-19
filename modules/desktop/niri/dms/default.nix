{ inputs, ... }:

{
  home-manager.sharedModules = [
    ({ lib, ... }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        enableCalendarEvents = false;
      };

      xdg.configFile."niri/dms/binds.kdl" = {
        source = ./binds.kdl;
        force = true;
      };

      home.activation.seedDmsSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        settings="$HOME/.config/DankMaterialShell/settings.json"

        if [ ! -e "$settings" ]; then
          mkdir -p "$(dirname "$settings")"
          install -m 600 ${./settings.json} "$settings"
        fi
      '';
    })
  ];
}
