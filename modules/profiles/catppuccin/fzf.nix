# SPDX-License-Identifier: MIT
# Copyright (c) 2023 Catppuccin
# Source: https://github.com/catppuccin/nix
{lib, ...}: {
  hm = {config, ...}:
    lib.mkIf config.programs.fzf.enable {
      home.sessionVariables = {
        # Reference: https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-macchiato.sh
        FZF_DEFAULT_OPTS = "--color=bg+:#363A4F,bg:#24273A,spinner:#F4DBD6,hl:#ED8796,fg:#CAD3F5,header:#ED8796,info:#C6A0F6,pointer:#F4DBD6,marker:#B7BDF8,fg+:#CAD3F5,prompt:#C6A0F6,hl+:#ED8796,selected-bg:#494D64,border:#6E738D,label:#CAD3F5";
      };
    };
}
