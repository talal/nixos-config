{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.unstable.hunk
  ];

  hm = {
    xdg.configFile."hunk/config.toml".source = (pkgs.formats.toml {}).generate "hunk-config.toml" {
      theme = "catppuccin-mocha";
      mode = "auto";
      hunk_headers = false;
      line_numbers = true;
      menu_bar = false;
      wrap_lines = true;
    };
  };
}
