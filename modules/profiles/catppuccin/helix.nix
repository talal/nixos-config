# SPDX-License-Identifier: MIT
# Copyright (c) 2023 Catppuccin
# Source: https://github.com/catppuccin/nix
{
  config,
  pkgs,
  ...
}: let
  cfg = config.catppuccin;
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  themeSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "helix";
    inherit (sources.helix) rev hash;
  };
in {
  hm = _: {
    xdg.configFile = {
      "helix/themes/catppuccin_${cfg.flavor}_upstream.toml".source = "${themeSrc}/themes/default/catppuccin_${cfg.flavor}.toml";

      "helix/themes/catppuccin_${cfg.flavor}_transparent.toml".text = ''
        inherits = "catppuccin_${cfg.flavor}_upstream"
        "ui.background" = {}
      '';
    };
  };
}
