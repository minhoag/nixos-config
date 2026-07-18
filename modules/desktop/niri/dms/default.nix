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

      home.activation.seedDmsSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        settings="$HOME/.config/DankMaterialShell/settings.json"

        if [ ! -e "$settings" ]; then
          mkdir -p "$(dirname "$settings")"
          cp ${./settings.json} "$settings"
          chmod u+w "$settings"
        fi
      '';
    })
  ];
}
