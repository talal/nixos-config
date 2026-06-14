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
    repo = "thunderbird";
    inherit (sources.thunderbird) rev hash;
  };
in {
  hm = {config, ...}:
    lib.mkIf config.programs.thunderbird.enable {
      programs.thunderbird = {
        profiles.default.extensions = [
          (
            pkgs.runCommandLocal "catppuccin-${cfg.flavor}-${cfg.accent}.thunderbird.theme"
            {
              nativeBuildInputs = with pkgs; [jq unzip];
            }
            ''
              xpi=${src}/themes/${cfg.flavor}/${cfg.flavor}-${cfg.accent}.xpi
              extId=$(unzip -qc $xpi manifest.json | jq -r .applications.gecko.id)
              extensionPath="extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
              install -Dv $xpi $out/share/mozilla/$extensionPath/$extId.xpi
            ''
          )
        ];
      };
    };
}
