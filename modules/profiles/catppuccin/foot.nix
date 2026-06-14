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
    repo = "foot";
    inherit (sources.foot) rev hash;
  };
in {
  hm = {config, ...}:
    lib.mkIf config.programs.foot.enable {
      programs.foot = {
        settings = {
          main.include = "${src}/themes/catppuccin-${cfg.flavor}.ini";
        };
      };
    };
}
