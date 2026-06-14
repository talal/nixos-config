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
    repo = "television";
    inherit (sources.television) rev hash;
  };
  themeName = "catppuccin-${cfg.flavor}-${cfg.accent}";
in {
  hm = {config, ...}:
    lib.mkIf config.programs.television.enable {
      programs.television = {
        settings = {
          ui.theme = themeName;
        };
      };
      xdg.configFile."television/themes/${themeName}.toml".source = "${src}/themes/${themeName}.toml";
    };
}
