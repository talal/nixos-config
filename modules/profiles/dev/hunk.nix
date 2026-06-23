{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
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
