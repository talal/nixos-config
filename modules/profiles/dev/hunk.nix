{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.unstable.hunk
  ];

  hm = {
    xdg.configFile."hunk/config.toml".source = (pkgs.formats.toml {}).generate "hunk-config.toml" {
      theme = "catppuccin-mocha";
      mode = "auto";
      line_numbers = true;
      wrap_lines = true;
    };
  };
}
