{
  inputs,
  pkgs,
  ...
}: {
  hm = {
    home.packages = [
      inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.hunk
    ];

    xdg.configFile."hunk/config.toml".source = (pkgs.formats.toml {}).generate "hunk-config" {
      theme = "catppuccin-mocha";
      mode = "auto";
      line_numbers = true;
      wrap_lines = true;
    };
  };
}
