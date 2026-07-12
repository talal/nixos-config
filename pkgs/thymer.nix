{
  lib,
  fetchurl,
  appimageTools,
  makeWrapper,
}: let
  pname = "thymer";
  version = "1.0.18";
  src = fetchurl {
    url = "https://updates.thymer.com/desktop/Thymer-${version}.AppImage";
    hash = "sha256-i7hXlAD0K2DBiBbZMHRnQVpuo70ZHa7IwwSu8tajacs=";
  };
  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    nativeBuildInputs = [makeWrapper];

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/thymer.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/thymer.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=thymer %U'

      cp -r ${appimageContents}/usr/share/icons $out/share

      wrapProgram $out/bin/thymer \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3}}"
    '';

    meta = {
      description = "IDE for tasks, notes, and planning";
      homepage = "https://thymer.com/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.linux;
      mainProgram = "thymer";
    };
  }
