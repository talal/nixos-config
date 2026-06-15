{findModulesList, ...}: {
  imports = findModulesList ./.;

  # keep-sorted start block=yes newline_separated=yes prefix_order=environment,security,services,programs,home-manager
  environment.sessionVariables = {
    # Use native Wayland when possible.
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # this should be enough for most Electron apps
    NIXOS_OZONE_WL = "1"; # apply wayland specific Nixpkgs flags
  };

  security.polkit.enable = true;

  services = {
    # keep-sorted start
    flatpak.enable = true;
    fwupd.enable = true;
    gnome.sushi.enable = true; # for Nautilus quick preview
    gvfs.enable = true;
    udisks2.enable = true; # auto-mounting disk
    # keep-sorted end
  };

  programs = {
    gnome-disks.enable = true;

    # Allows to run unpatched dynamic binaries, e.g. those downloaded by cargo/rustup.
    # Without this, simple things like 'cargo run' might crash on missing libs.
    nix-ld.enable = true;
  };
  # keep-sorted end
}
