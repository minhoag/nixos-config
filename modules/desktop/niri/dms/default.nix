{
  home-manager.sharedModules = [
    ({ inputs, ... }: {
      imports = [
        inputs.dms.homeModules.dank-material-shell
        inputs.dms.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
        enableCalendarEvents = false;
      };
    })
  ];
}
