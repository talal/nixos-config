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
    repo = "btop";
    inherit (sources.btop) rev hash;
  };
  themeFile = "catppuccin_${cfg.flavor}.theme";
in {
  hm = {config, ...}:
    lib.mkIf config.programs.btop.enable {
      programs.btop.settings.color_theme = themeFile;
      xdg.configFile."btop/themes/${themeFile}".source = "${src}/themes/${themeFile}";
    };
}
