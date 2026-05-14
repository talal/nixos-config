{pkgs, ...}: {
  services.pcscd = {
    enable = true;
    plugins = [pkgs.ccid];
  };

  home-manager.users.talal = {
    home.packages = with pkgs; [
      unstable.age-plugin-yubikey
      yubioath-flutter
    ];
  };
}
