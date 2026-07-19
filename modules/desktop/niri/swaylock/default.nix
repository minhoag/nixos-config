{ pkgs, ... }:

{
  home-manager.sharedModules = [
    (
      { config, ... }:
      {

        # 1. Configure Swaylock / Swaylock-effects
        programs.swaylock = {
          enable = true;
          # Force home-manager to use the swaylock-effects package for blur features
          package = pkgs.swaylock-effects;
          settings = {
            # swaylock-effects arguments here:
            screenshots = true;
            clock = true;
            indicator = true;
            indicator-radius = 100;
            indicator-thickness = 7;
            effect-blur = "10x5"; # Smooth blur effect for behind the lock screen
            effect-vignette = "0.5:0.5";
            # Background color
            color = "#191724";
            # Layout text colors
            layout-bg-color = "#00000000";
            layout-border-color = "#00000000";
            layout-text-color = "#e0def4";
            # Text color
            text-color = "#31748f";
            text-clear-color = "#9ccfd8";
            text-caps-lock-color = "#f6c177";
            text-ver-color = "#c4a7e7";
            text-wrong-color = "#eb6f92";
            # Highlight segments
            bs-hl-color = "#19172466";
            key-hl-color = "#31748f";
            caps-lock-bs-hl-color = "#19172466";
            caps-lock-key-hl-color = "#f6c177";
            # Highlight segments separator
            separator-color = "#00000000";
            # Inside of the indicator
            inside-color = "#31748f55";
            inside-clear-color = "#9ccfd855";
            inside-caps-lock-color = "#f6c17755";
            inside-ver-color = "#c4a7e755";
            inside-wrong-color = "#eb6f9255";
            # Line between the inside and ring
            line-color = "#31748f11";
            line-clear-color = "#9ccfd811";
            line-caps-lock-color = "#f6c17711";
            line-ver-color = "#c4a7e711";
            line-wrong-color = "#eb6f9211";
            # Indicator ring
            ring-color = "#31748faa";
            ring-clear-color = "#9ccfd8aa";
            ring-caps-lock-color = "#f6c177aa";
            ring-ver-color = "#c4a7e7aa";
            ring-wrong-color = "#eb6f92aa";
          };
        };
        # 2. Configure Swayidle (Idling daemon for Niri)
        services.swayidle = {
          enable = true;
          # Updated syntax: events is now an attrset keyed by the event name
          events = {
            before-sleep = "${pkgs.swaylock-effects}/bin/swaylock -f";
          };
          timeouts = [
            # Timeout 1: Lock the screen after 5 minutes of inactivity
            {
              timeout = 300;
              command = "${pkgs.swaylock-effects}/bin/swaylock -f";
            }
            # Timeout 2: Turn off the displays via Niri 2 minutes after locking
            {
              timeout = 420;
              command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
              # Turn screens back on when activity is detected
              resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
            }
          ];
        };
      }
    )
  ];
}
