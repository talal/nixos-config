{pkgs, ...}: {
  services.pcscd = {
    enable = true;
    plugins = [pkgs.ccid];
  };

  environment.systemPackages = with pkgs; [
    unstable.age-plugin-yubikey
    yubioath-flutter
  ];
}
