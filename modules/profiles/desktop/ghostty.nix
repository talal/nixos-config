{pkgs, ...}: {
  hm = {
    programs.ghostty = {
      enable = true;
      package = pkgs.unstable.ghostty;
      settings = {
        command = "fish";
        theme = "alabaster-dark";
        background-opacity = 0.90;
        background-blur = true;
        mouse-hide-while-typing = true;
        quit-after-last-window-closed = true;
        quit-after-last-window-closed-delay = "30m";
        window-padding-x = 6;
        window-padding-y = 0;

        font-size = 14;
        font-family = [
          "TX-02"
          "NoName Fixed Terminal"
          "Symbols Nerd Font"
        ];
        adjust-cell-height = "15%";
        adjust-cell-width = "0%";
        adjust-underline-position = 2;
        adjust-underline-thickness = -1;

        keybind = [
          "global:ctrl+backquote=toggle_quick_terminal"

          "ctrl+enter=unbind" # conflicts with WM keybind
          "ctrl+shift+q=unbind" # prevent accidental quit

          # Remap from 'close_tab:this' to 'close_surface' because the latter will also
          # close current tab if it has has only pane (i.e. root pane). This prevents
          # accidental closure of tabs which have multiple panes in them.
          "ctrl+shift+w=close_surface"

          # ctrl+page_down/up are set to next/previous_tab by default.
          "ctrl+shift+page_down=move_tab:1"
          "ctrl+shift+page_up=move_tab:-1"

          # ctrl+arrow_keys are already set by default.
          "ctrl+alt+h=goto_split:left"
          "ctrl+alt+j=goto_split:down"
          "ctrl+alt+k=goto_split:up"
          "ctrl+alt+l=goto_split:right"
        ];

        gtk-wide-tabs = false;
        gtk-custom-css = "${pkgs.writeText "ghostty-tab-style.css" ''
          /*
            debug: env GTK_DEBUG=interactive ghostty
            https://docs.gtk.org/gtk4/css-overview.html
            https://docs.gtk.org/gtk4/css-properties.html
          */

          headerbar,
          tabbar,
          tabbar tabbox,
          tabbar tabbox tab,
          tabbar tabbox button {
            min-height: 0;
            padding: 0;
            margin: 0;
          }

          tabbar {
            background-color: #141a1b;
          }

          tabbar tabbox {
            font-family: "JetBrains Mono", monospace;
          }

          tabbar tabbox tab {
            padding: 1px 10px;
          }

          tabbar tabbox tab:checked {
            background-color: #3d5457;
          }

          tabbar tabbox tab label {
            font-size: 13px;
          }
        ''}";
      };
    };

    xdg.configFile."ghostty/themes/alabaster-dark".text = ''
      # Alabaster Dark — ported from kitty-alabaster (alabaster-dark.conf)
      # Original author: Anmol Mathias (MIT license)
      # Upstream (kitty): https://raw.githubusercontent.com/anmolmathias/kitty-alabaster/master/alabaster-dark.conf
      # Adapted from Nikita Prokopov's Alabaster color scheme, ported here for Ghostty.

      background = #0e1415
      foreground = #cecece

      cursor-color = #cd974b
      cursor-text = #000000

      selection-background = #293334
      selection-foreground = #cecece

      palette = 0=#000000
      palette = 1=#e25d56
      palette = 2=#73ca50
      palette = 3=#e9bf57
      palette = 4=#4a88e4
      palette = 5=#915caf
      palette = 6=#23acdd
      palette = 7=#cecece
      palette = 8=#777777
      palette = 9=#f36868
      palette = 10=#88db3f
      palette = 11=#f0bf7a
      palette = 12=#6f8fdb
      palette = 13=#e987e9
      palette = 14=#4ac9e2
      palette = 15=#ffffff
    '';
  };
}
