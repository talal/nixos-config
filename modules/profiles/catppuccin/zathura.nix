# SPDX-License-Identifier: MIT
# Copyright (c) 2023 Catppuccin
# Source: https://github.com/catppuccin/nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.catppuccin;
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
  src = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zathura";
    inherit (sources.zathura) rev hash;
  };
in {
  hm = {config, ...}:
    lib.mkIf config.programs.zathura.enable {
      programs.zathura = {
        options = {
          extraConfig = ''
            include ${src}/themes/catppuccin-${cfg.flavor}
          '';

          # Tweak catpuccin theme for better readability.
          recolor = false;
          highlight-active-color = "rgba(245, 194, 231, 0.5)";
          highlight-color = "rgba(183, 189, 248, 0.5)";
          highlight-fg = "#24273a";
        };
      };
    };
}
