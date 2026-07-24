{ inputs, pkgs, ... }:
let
  caelestiaWallpaperEngine = import ./caelestia/caelestia-wallpaperengine.nix { inherit pkgs; };
  hyprConfig = pkgs.runCommand "caelestia-hypr-config" { nativeBuildInputs = [ pkgs.lua ]; } ''
    cp -r ${inputs.caelestia-dots}/hypr $out
    chmod -R u+w $out
    cp $out/scheme/default.lua $out/scheme/current.lua
    cp ${./caelestia/keybinds.lua} $out/hyprland/keybinds.lua
    substituteInPlace $out/hyprland.lua \
      --replace-fail 'local overrides = require("hypr-vars")' $'local ok, overrides = pcall(require, "hypr-vars")\nif not ok then overrides = {} end' \
      --replace-fail 'require("hypr-user")' 'pcall(require, "hypr-user")'
    substituteInPlace $out/hyprland/execs.lua \
      --replace-fail $'    -- Start shell\n    hl.exec_cmd("caelestia shell -d")\n' ""

    shopt -s globstar nullglob
    for file in $out/**/*.lua; do
      luac -p "$file"
    done
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
    hotkeyhub
    swappy
    wl-clipboard
    ydotool
  ];

  home-manager.sharedModules = [
    inputs.caelestia-shell.homeManagerModules.default
    (
      {
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = [ caelestiaWallpaperEngine ];

        xdg.configFile = {
          hypr.source = hyprConfig;
          caelestia.source = ./caelestia;
        };

        home.activation.removeNiriState = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "$HOME/.config/niri" "$HOME/.config/DankMaterialShell"
        '';

        programs.caelestia = {
          enable = true;
          systemd.enable = true;
          cli.enable = true;
          package =
            inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs
              (old: {
                postPatch = (old.postPatch or "") + ''
                  cp -r ${./caelestia/quickshell}/. .
                '';
              });
        };
      }
    )
  ];
}
