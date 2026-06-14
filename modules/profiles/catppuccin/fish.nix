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
    repo = "fish";
    inherit (sources.fish) rev hash;
  };
  themeName = "catppuccin-${cfg.flavor}";
in {
  hm = {config, ...}:
    lib.mkIf config.programs.fish.enable {
      xdg.configFile."fish/themes/${themeName}.theme".source = "${src}/static/${themeName}.theme";
      programs.fish.shellInit = ''
        fish_config theme choose "${themeName}"
      '';
    };
}
