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
    repo = "bat";
    inherit (sources.bat) rev hash;
  };
  flavorCapitalized =
    {
      latte = "Latte";
      frappe = "Frappe";
      macchiato = "Macchiato";
      mocha = "Mocha";
    }.${
      cfg.flavor
    };
  themeName = "Catppuccin ${flavorCapitalized}";
in {
  hm = {config, ...}:
    lib.mkIf config.programs.bat.enable {
      programs.bat = {
        config.theme = themeName;
        themes.${themeName} = {
          inherit src;
          file = "${themeName}.tmTheme";
        };
      };
    };
}
