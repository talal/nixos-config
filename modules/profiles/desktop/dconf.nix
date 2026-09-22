{inputs, ...}: let
  ptyxisProfileUUID = "a675216307e9744d21b89c516ab22fc2";
in {
  programs.dconf.enable = true;

  hm = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "adw-gtk3-dark";
        icon-theme = "Adwaita";
      };

      "org/gnome/TextEditor" = {
        restore-session = false;
        use-system-font = false;
        custom-font = "monospace 13";
        highlight-current-line = true;
        show-line-numbers = true;
        tab-width = inputs.home-manager.lib.hm.gvariant.mkUint32 4;
        style-scheme = "Adwaita-dark";
      };

      "org/gnome/Ptyxis" = {
        profile-uuids = [ptyxisProfileUUID];
        default-profile-uuid = ptyxisProfileUUID;
        audible-bell = false;
        visual-bell = false;
        use-system-font = false;
        cursor-shape = "ibeam";
        font-name = "termono 14";
      };

      "org/gnome/Ptyxis/Profiles/${ptyxisProfileUUID}" = {
        label = "main";
        login-shell = false;
        use-custom-command = true;
        custom-command = "fish";
        cell-height-scale = 1.1;
        palette = "gnome";
      };
    };
  };
}
