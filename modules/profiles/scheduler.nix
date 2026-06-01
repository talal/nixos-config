{pkgs, ...}: {
  services.scx = {
    enable = true;
    package = pkgs.unstable.scx.rustscheds;
    scheduler = "scx_bpfland";
  };
}
