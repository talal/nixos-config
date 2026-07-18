{
  fetchurl,
  stdenv,
  lib,
  buildFHSEnv,
  appimageTools,
  writeShellScript,
  unzip,
  makeDesktopItem,
  commandLineArgs ? [],
}: let
  pname = "logseq-bin";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/Logseq-linux-x86_64-${version}.zip";
    sha256 = "05vs60g7gkjb5hy597cja2dp5c4vsaakf6936bw5ws03fkrz26wq";
  };

  icon = fetchurl {
    url = "https://raw.githubusercontent.com/logseq/logseq/master/resources/icons/logseq.png";
    sha256 = "0yjmzygjpa1x45li6hi1yvfic1v2hnlwxh2mnmgcra9q842ir073";
  };

  unpacked = stdenv.mkDerivation {
    inherit pname version src;

    nativeBuildInputs = [unzip];
    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/opt/logseq
      cp -r * $out/opt/logseq/

      runHook postInstall
    '';
  };

  meta = {
    description = "A privacy-first, open-source platform for knowledge management and collaboration";
    homepage = "https://logseq.com/";
    license = lib.licenses.agpl3Plus;
    platforms = ["x86_64-linux"];
    mainProgram = "logseq-desktop";
  };

  desktopItem = makeDesktopItem {
    name = "logseq";
    desktopName = "Logseq";
    exec = "logseq-desktop %u";
    icon = "logseq";
    comment = meta.description;
    categories = ["Office" "Utility"];
    mimeTypes = ["x-scheme-handler/logseq"];
  };

  fhsEnvLogseq = buildFHSEnv (
    appimageTools.defaultFhsEnvArgs
    // {
      pname = "logseq-desktop";
      inherit version;

      runScript = writeShellScript "logseq-wrapper.sh" ''
        OZONE_ARGS=""
        if [[ -n "$NIXOS_OZONE_WL" && -n "$WAYLAND_DISPLAY" && "$ELECTRON_RUN_AS_NODE" != "1" ]]; then
          OZONE_ARGS="--ozone-platform=wayland --enable-wayland-ime=true --wayland-text-input-version=3"
        fi
        export APPIMAGE="logseq-desktop"
        exec ${unpacked}/opt/logseq/logseq $OZONE_ARGS ${lib.strings.escapeShellArgs commandLineArgs} "$@"
      '';

      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
        cp ${desktopItem}/share/applications/* $out/share/applications/
        cp ${icon} $out/share/icons/hicolor/256x256/apps/logseq.png
      '';

      inherit meta;
    }
  );
in
  fhsEnvLogseq
