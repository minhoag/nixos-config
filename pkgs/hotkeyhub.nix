{
  fetchFromGitHub,
  lib,
  pkg-config,
  rustPlatform,
  wrapGAppsHook4,
  gtk4,
}:
rustPlatform.buildRustPackage {
  pname = "hotkeyhub";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "meowrch";
    repo = "HotKeyHub";
    rev = "6c8fb0bd19ce8fbbc66802eec0e6e81331264071";
    hash = "sha256-LfURG3FoJLWkMt497uvsaLdOboWHhOkqmvwZMy3B/OQ=";
  };

  cargoHash = "sha256-EXB9AmLOacpM73BRcotxEGeS1jgmEcgggypu5EvD9nQ=";
  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ gtk4 ];

  postInstall = ''
    install -Dm644 hotkeyhub.desktop $out/share/applications/hotkeyhub.desktop
    install -Dm644 hotkeyhub.png $out/share/pixmaps/hotkeyhub.png
  '';

  meta = {
    description = "Keyboard shortcut reference for Hyprland";
    homepage = "https://github.com/meowrch/HotKeyHub";
    license = lib.licenses.gpl3Only;
    mainProgram = "hotkeyhub";
    platforms = lib.platforms.linux;
  };
}
