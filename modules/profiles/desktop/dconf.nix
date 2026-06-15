{inputs, ...}: {
  programs.dconf.enable = true;

  hm = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Adwaita";
      };

      "org/gnome/TextEditor" = {
        custom-font = "monospace 13";
        restore-session = false;
        show-line-numbers = true;
        tab-width = inputs.home-manager.lib.hm.gvariant.mkUint32 4;
        use-system-font = false;
      };
    };
  };
}
