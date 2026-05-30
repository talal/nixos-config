{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  makeWrapper,
  libadwaita,
  libepoxy,
  mpv,
  glib,
  wrapGAppsHook4,
}:
rustPlatform.buildRustPackage rec {
  pname = "losange";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "tymmesyde";
    repo = "losange";
    rev = "v${version}";
    hash = "sha256-mr54/vnaopLwG9lhFiZJGgxWH/VaGitROVEeV7GSyHM=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "localsearch-0.1.0" = "sha256-wWmusHYmT7wtN+mgGvTMUbp0JXYsbpZRfb5qQfQLdlQ=";
      "stremio-core-0.1.0" = "sha256-RCU9oHBLbeuZk/cx4V17jf3Cx30XS8TMIx9W+WnIoj8=";
    };
  };

  buildInputs = [
    mpv
    libadwaita
    libepoxy
    openssl
  ];

  nativeBuildInputs = [
    glib
    wrapGAppsHook4
    makeWrapper
    pkg-config
  ];

  postInstall = ''
    install -Dm444 $src/data/xyz.timtimtim.Losange.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/

    install -Dm444 $src/data/icons/xyz.timtimtim.Losange.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 $src/data/xyz.timtimtim.Losange.desktop -t $out/share/applications/
    install -Dm444 $src/data/xyz.timtimtim.Losange.metainfo.xml -t $out/share/metainfo/

    substituteInPlace $out/share/applications/xyz.timtimtim.Losange.desktop \
      --replace "Exec=sh -c \"/usr/bin/losange -o '%u'\"" "Exec=losange"
  '';

  meta = {
    mainProgram = "losange";
    description = "A simple Stremio client for GNOME";
    homepage = "https://github.com/tymmesyde/Losange";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
