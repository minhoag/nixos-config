{
  cmake,
  fetchFromGitHub,
  go,
  ibus,
  lib,
  pkg-config,
  qt6,
  stdenv,
  wayland,
}:
stdenv.mkDerivation {
  pname = "unikey-wayland";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "ubuntu2310fake";
    repo = "Unikey-Wayland";
    rev = "401d20b911ef909c3a52cec78bb0bca08e960273";
    hash = "sha256-if8CFWbHgFwoIJ1pMnRXMzTL5kXWAxHogZpDRBzYfmE=";
  };

  sourceRoot = "source/wayland-client";
  nativeBuildInputs = [ cmake go pkg-config qt6.wrapQtAppsHook ];
  buildInputs = [ ibus qt6.qtbase wayland ];

  preBuild = ''
    export GOCACHE="$TMPDIR/go-build"
  '';

  postPatch = ''
    substituteInPlace ../ibus-engine/unikey-wayland.xml \
      --replace-fail /usr/libexec "$out/libexec" \
      --replace-fail /usr/bin "$out/bin"
  '';

  meta = {
    description = "Vietnamese input method with a native Wayland and IBus backend";
    homepage = "https://github.com/ubuntu2310fake/Unikey-Wayland";
    isIbusEngine = true;
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
