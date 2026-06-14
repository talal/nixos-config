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
    repo = "atuin";
    inherit (sources.atuin) rev hash;
  };
  themeName = "catppuccin-${cfg.flavor}-${cfg.accent}";
in {
  hm = {config, ...}:
    lib.mkIf config.programs.atuin.enable {
      programs.atuin.settings.theme.name = themeName;
      xdg.configFile."atuin/themes/${themeName}.toml".source = "${src}/themes/${cfg.flavor}/${themeName}.toml";
    };
}
