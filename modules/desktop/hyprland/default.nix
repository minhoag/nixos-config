{ inputs, pkgs, ... }:
let
  hyprConfig = pkgs.runCommand "caelestia-hypr-config" { } ''
    cp -r ${inputs.caelestia-dots}/hypr $out
    chmod -R u+w $out
    cp $out/scheme/default.lua $out/scheme/current.lua
  '';
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages = with pkgs; [
    cliphist
    hyprpicker
    swappy
    wl-clipboard
    ydotool
  ];

  home-manager.sharedModules = [
    inputs.caelestia-shell.homeManagerModules.default
    ({ lib, ... }: {
      xdg.configFile = {
        hypr.source = hyprConfig;
        caelestia.source = ./caelestia;
      };

      home.activation.removeNiriState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        rm -rf "$HOME/.config/niri" "$HOME/.config/DankMaterialShell"
      '';

      programs.caelestia = {
        enable = true;
        systemd.enable = false;
        cli.enable = true;
      };
    })
  ];
}
