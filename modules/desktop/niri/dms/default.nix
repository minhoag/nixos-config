{
  home-manager.sharedModules = [
    ({ inputs, pkgs, ... }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        enableCalendarEvents = false;
      };

      home.activation.seedDmsSettings = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        DMS_SETTINGS="$HOME/.config/DankMaterialShell/settings.json"

        if [ ! -e "$DMS_SETTINGS" ]; then
          mkdir -p "$(dirname "$DMS_SETTINGS")"
          cp ${./dms-settings.json} "$DMS_SETTINGS"
          chmod u+w "$DMS_SETTINGS"
        fi
      '';
    })
  ];
}
