{ pkgs, ... }:
let
  whiteSur = pkgs.fetchFromGitHub {
    owner = "vinceliuice";
    repo = "WhiteSur-firefox-theme";
    rev = "2026-07-07";
    hash = "sha256-6XSIEtqs+pDULvON31uLC51tcEvyBVOvO6P2zR+IWAw=";
  };
  montereyChrome = pkgs.runCommand "monterey-firefox-theme" { } ''
    mkdir -p $out
    cp -r ${whiteSur}/src/Monterey $out/Monterey
    chmod -R u+w $out/Monterey
    cp -r ${whiteSur}/src/common/{icons,titlebuttons,pages} $out/Monterey
    cp ${whiteSur}/src/common/*.css $out/Monterey
    cp ${whiteSur}/src/common/parts/*.css $out/Monterey/parts
    cp ${whiteSur}/src/WhiteSur/parts/headerbar-urlbar.css $out/Monterey/parts/headerbar-urlbar-alt.css
    cp ${whiteSur}/src/userChrome-Monterey-alt.css $out/userChrome.css
    cp ${whiteSur}/src/userContent-Monterey.css $out/userContent.css
    cp ${whiteSur}/src/customChrome.css $out
  '';
in
{
  home-manager.sharedModules = [
    {
      programs.firefox.profiles.default = {
        path = "e5hjps8r.default";
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "browser.tabs.drawInTitlebar" = true;
          "browser.uidensity" = 0;
          "layers.acceleration.force-enabled" = true;
          "mozilla.widget.use-argb-visuals" = true;
          "widget.gtk.rounded-bottom-corners.enabled" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
      home.file.".mozilla/firefox/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=../../.config/mozilla/firefox/e5hjps8r.default
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';
      xdg.configFile."mozilla/firefox/e5hjps8r.default/chrome".source = montereyChrome;
    }
  ];
}
