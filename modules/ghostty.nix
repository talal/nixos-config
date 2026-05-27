{pkgs, ...}: {
  hm = {
    programs.ghostty = {
      enable = true;
      package = pkgs.unstable.ghostty;
      settings = {
        command = "fish";
        theme = "Catppuccin Macchiato";
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
          "Symbols Nerd Font"
        ];
        adjust-cell-height = "15%";
        adjust-cell-width = "0%";
        adjust-underline-position = 2;
        adjust-underline-thickness = -1;

        gtk-wide-tabs = false;
        gtk-custom-css = "tab-style.css";

        keybind = [
          "ctrl+enter=unbind"
          "ctrl+shift+q=unbind"

          "global:ctrl+backquote=toggle_quick_terminal"

          # Tabs
          # ctrl+page_down/up will switch tabs by default.
          "ctrl+shift+page_down=move_tab:1"
          "ctrl+shift+page_up=move_tab:-1"
          "ctrl+shift+alt+t=prompt_surface_title"

          # Splits: use ctrl+shift+<key> since ctrl+<key> is used for Helix splits.
          "ctrl+shift+h=goto_split:left"
          "ctrl+shift+j=goto_split:down"
          "ctrl+shift+k=goto_split:up"
          "ctrl+shift+l=goto_split:right"
        ];
      };
    };

    xdg.configFile."ghostty/tab-style.css".text = ''
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
        background-color: #232638;
      }

      tabbar tabbox {
        font-family: "JetBrains Mono", monospace;
      }

      tabbar tabbox tab {
        padding: 1px 10px;
      }

      tabbar tabbox tab label {
        font-size: 13px;
      }
    '';
  };
}
