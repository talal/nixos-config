{
  inputs,
  lib,
  pkgs,
  ...
}: let
  niriPkg = pkgs.unstable.niri;
  vicinaePkg = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  imports = [inputs.dms.nixosModules.dank-material-shell];

  # ══════════ Compositor ══════════
  programs.niri = {
    enable = true;
    package = niriPkg;
  };

  # ══════════ Shell ══════════
  programs.dank-material-shell = {
    enable = true;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    enableAudioWavelength = false;
    enableCalendarEvents = false;
    enableClipboardPaste = false;
  };

  # ══════════ Launcher ══════════
  users.users.talal.extraGroups = ["input"];
  services.udev.extraRules = ''
    # Allows vicinae to create a virtual keyboard: required for paste support (the current user needs to be in the 'input' group)
    KERNEL=="uinput", GROUP="input", MODE="0660", RUN+="${pkgs.acl}/bin/setfacl -m g:input:rw /dev/$name"
  '';
  security.wrappers.vicinae-input-server = {
    source = "${vicinaePkg}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };

  # ══════════ Login Manager ══════════
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      command = ''${lib.getExe pkgs.tuigreet} --remember --time --asterisks --cmd ${lib.getExe' niriPkg "niri-session"}'';
      user = "greeter";
    };
  };
  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;

    # Disable fingerprint auth for greetd; use password instead.
    # fprintd's PAM hook would otherwise stack `pam_fprintd.so sufficient` ahead of
    # pam_unix and the user sees a fingerprint scan request. If fingerprint is used at
    # login then keyring doesn't get unlocked automatically.
    greetd.fprintAuth = false;
  };

  # keep-sorted start block=yes newline_separated=yes prefix_order=security,services,programs,environment,home-manager
  security.polkit.enable = true;

  services = {
    # keep-sorted start
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.sushi.enable = true; # for Nautilus quick preview
    gvfs.enable = true;
    power-profiles-daemon.enable = true;
    udisks2.enable = true; # auto-mounting disk
    upower.enable = true; # power management D-Bus
    # keep-sorted end
  };

  programs = {
    dconf.enable = true;
    gnome-disks.enable = true;
  };

  environment.sessionVariables = {
    # Ensure deadkeys work.
    GTK_IM_MODULE = "simple";

    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags

    # Niri
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "gtk3";
    QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  environment.systemPackages = with pkgs; [
    # ══════════ Applications ══════════
    # keep-sorted start ignore_prefixes=inputs. prefix_order=unstable
    unstable.bitwarden-desktop
    unstable.discord
    unstable.ente-desktop
    unstable.obsidian
    unstable.stremio-linux-shell
    blanket
    czkawka
    gimp
    gnome-calculator
    gnome-text-editor
    keepassxc
    libreoffice-still
    loupe
    nautilus
    papers
    parabolic
    pdfarranger
    pika-backup
    proton-authenticator
    resources
    signal-desktop
    zeal
    # keep-sorted end

    # ══════════ Utilities ══════════
    # keep-sorted start ignore_prefixes=inputs.,unstable.
    adw-gtk3 # GTK theme
    adwaita-icon-theme
    apple-cursor
    unstable.amd-debug-tools
    choose
    exiftool
    ffmpeg-full
    fzf
    git-cliff
    git-filter-repo
    glow
    hexyl
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_GB-ize
    hyperfine
    poppler-utils # for yazi
    scc
    scooter
    unstable.snitch # TODO: not available in nixos-25.11 therefore using nixpkgs-unstable
    vicinaePkg
    watchexec
    wl-screenrec
    xdg-utils
    xwayland-satellite # for niri xwayland compatibility
    # keep-sorted end
  ];
  # keep-sorted end

  home-manager.users.talal = {
    # ══════════ Dev ══════════
    home.packages = with pkgs.unstable; [
      # keep-sorted start
      devenv
      exercism
      jj-starship
      watchman # for jj fsmonitor
      yaak
      zed-editor
      # keep-sorted end

      # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts.
      # For everything else, use devenv.

      # keep-sorted start
      alejandra # nixfmt is yuck, alejandra is 👌
      bash-language-server
      just-lsp
      keep-sorted
      marksman # Markdown LSP
      mdformat
      nixd
      prettier # JSON formatting
      shellcheck
      shfmt
      superhtml
      taplo # TOML LSP
      tinymist
      treefmt
      typst # I use Typst alot so installing globally instead of devenv
      typstyle
      uv # for Python scripts
      vscode-css-languageserver
      vscode-json-languageserver
      yaml-language-server
      yamlfmt
      zizmor
      # keep-sorted end
    ];
  };
}
