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
  yaziSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "yazi";
    inherit (sources.yazi) rev hash;
  };
  batSrc = pkgs.fetchFromGitHub {
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
in {
  hm = {config, ...}:
    lib.mkIf config.programs.yazi.enable {
      xdg.configFile = {
        "yazi/theme.toml".source = "${yaziSrc}/themes/${cfg.flavor}/catppuccin-${cfg.flavor}-${cfg.accent}.toml";
        "yazi/Catppuccin-${cfg.flavor}.tmTheme".source = "${batSrc}/Catppuccin ${flavorCapitalized}.tmTheme";
      };
    };
}
