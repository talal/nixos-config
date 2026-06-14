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
    repo = "delta";
    inherit (sources.delta) rev hash;
  };
in {
  hm = {config, ...}:
    lib.mkIf config.programs.delta.enable {
      programs.delta.options.features = "catppuccin-${cfg.flavor}";
      programs.git = lib.mkIf config.programs.delta.enableGitIntegration {
        includes = [{path = "${src}/catppuccin.gitconfig";}];
      };
    };
}
