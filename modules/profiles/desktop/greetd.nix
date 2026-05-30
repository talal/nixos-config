{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings.default_session = {
      user = "greeter";
      command = lib.concatStringsSep " " [
        "${lib.getExe pkgs.tuigreet}"
        "--time"
        "--remember"
        "--remember-user-session"
        "--asterisks"
        "--sessions"
        "${pkgs-unstable.niri}/share/wayland-sessions"
      ];
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
}
