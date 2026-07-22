{
  cmake,
  fcitx5,
  fcitx5-bamboo,
  fetchFromGitHub,
  gettext,
  go,
  kdePackages,
  lib,
  libinput,
  libX11,
  pkg-config,
  stdenv,
  udev,
}:
stdenv.mkDerivation {
  pname = "fcitx5-vmk";
  version = "0.9.31";

  src = fetchFromGitHub {
    owner = "thanhpy2009";
    repo = "VMK";
    rev = "d38f08318edbe1a9c3fb43e6e707cfce5f72dba6";
    hash = "sha256-X8bPBBDkUFvFhS/4PMjkyY3vjcJf+u0fHpZVTaRiVYE=";
  };

  sourceRoot = "source/src-full";

  nativeBuildInputs = [ cmake kdePackages.extra-cmake-modules gettext go pkg-config ];
  buildInputs = [ fcitx5 libinput libX11 udev ];

  postPatch = ''
    cp -r ${fcitx5-bamboo.src}/bamboo .
    mkdir -p cmake
    cp ${fcitx5-bamboo.src}/cmake/FindPthread.cmake cmake/
    cp ${fcitx5-bamboo.src}/data/vietnamese.cm.dict data/
    chmod -R u+w bamboo cmake data
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'fcitx5_translate_desktop_file(vmk.conf.in vmk.conf) ' "" \
      --replace-fail '"''${CMAKE_CURRENT_BINARY_DIR}/vmk.conf"' '"''${CMAKE_CURRENT_SOURCE_DIR}/vmk.conf"' \
      --replace-fail 'configure_file(vmk-addon.conf.in.in vmk-addon.conf.in)' "" \
      --replace-fail 'fcitx5_translate_desktop_file("''${CMAKE_CURRENT_BINARY_DIR}/vmk-addon.conf.in" vmk-addon.conf)' "" \
      --replace-fail '"''${CMAKE_CURRENT_BINARY_DIR}/vmk-addon.conf"' '"''${CMAKE_CURRENT_SOURCE_DIR}/vmk-addon.conf.in.in"'
  '';

  preBuild = ''
    export GOCACHE="$TMPDIR/go-build"
  '';

  postBuild = ''
    $CXX -std=gnu++17 ../fcitx5_uinput_server.cpp \
      -o fcitx5_uinput_server \
      $(pkg-config --cflags --libs libinput libudev) -pthread
  '';

  postInstall = ''
    install -Dm755 fcitx5_uinput_server $out/libexec/fcitx5_uinput_server
  '';

  meta = {
    description = "No-preedit Vietnamese input method for Fcitx5";
    homepage = "https://github.com/thanhpy2009/VMK";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
