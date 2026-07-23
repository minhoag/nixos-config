{ inputs, pkgs, ... }:
let
  caelestiaWallpaperEngine = import ./caelestia/caelestia-wallpaperengine.nix { inherit pkgs; };
  hyprConfig = pkgs.runCommand "caelestia-hypr-config" { } ''
    cp -r ${inputs.caelestia-dots}/hypr $out
    chmod -R u+w $out
    cp $out/scheme/default.lua $out/scheme/current.lua
    cp ${./caelestia/keybinds.lua} $out/hyprland/keybinds.lua
    substituteInPlace $out/hyprland/execs.lua \
      --replace-fail $'    -- Start shell\n    hl.exec_cmd("caelestia shell -d")\n' ""
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
        config,
        lib,
        pkgs,
        ...
      }:
      {
        home.packages = [ caelestiaWallpaperEngine ];

        xdg.configFile = {
          hypr.source = hyprConfig;
          caelestia.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/desktop/hyprland/caelestia";
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
