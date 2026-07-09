{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # keep-sorted start
    age
    ffmpeg-full
    lm_sensors
    pciutils
    poppler-utils
    sops
    tree
    usbutils
    wl-clipboard
    # keep-sorted end
  ];
}
