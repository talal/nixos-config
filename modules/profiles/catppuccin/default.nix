# SPDX-License-Identifier: MIT
# Copyright (c) 2023 Catppuccin
# Source: https://github.com/catppuccin/nix
# The following programs are intentionally excluded from this profile:
# - bottom: IFD
# - eza: IFD (can use term colors)
# - firefox: IFD
# - gemini-cli: Disabled
# - ghostty: Use built-in theme
# - mpv: Don't need
# - starship: IFD (can use term colors)
{
  lib,
  findModulesList,
  ...
}: {
  imports = findModulesList ./.;

  options.catppuccin = {
    flavor = lib.mkOption {
      type = lib.types.enum ["latte" "frappe" "macchiato" "mocha"];
      default = "macchiato";
      description = "Catppuccin flavor";
    };

    accent = lib.mkOption {
      type = lib.types.enum ["rosewater" "flamingo" "pink" "mauve" "red" "maroon" "peach" "yellow" "green" "teal" "sky" "sapphire" "blue" "lavender"];
      default = "lavender";
      description = "Catppuccin accent";
    };
  };
}
