{
  lib,
  pkgs,
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
        "${pkgs.unstable.niri}/share/wayland-sessions"
      ];
    };
  };

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;

    # Disable fingerprint auth for greetd and use password instead so that login keyring
    # gets unlocked automatically.
    # If we don't disable this then fprintd's PAM hook would stack `pam_fprintd.so sufficient`
    # ahead of pam_unix and the user would see a fingerprint scan request instead of
    # password entry during login.
    greetd.fprintAuth = false;
  };
}
