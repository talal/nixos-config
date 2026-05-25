{
  config,
  lib,
  pkgs,
  ...
}: let
  vicinaePkg = pkgs.unstable.vicinae;
in {
  environment.systemPackages = [vicinaePkg];

  services.udev.extraRules = ''
    # Allows vicinae to create a virtual keyboard: required for paste support (the current user needs to be in the 'input' group)
    KERNEL=="uinput", GROUP="input", MODE="0660", RUN+="${pkgs.acl}/bin/setfacl -m g:input:rw /dev/$name"
  '';
  users.users.${config.user}.extraGroups = ["input"];

  security.wrappers.vicinae-input-server = {
    source = "${vicinaePkg}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };

  hjem.users.${config.user} = {
    xdg.config.files."vicinae/user_settings.json" = {
      generator = lib.generators.toJSON {};
      value = {
        pop_to_root_on_close = true;
        font.normal = {
          family = "Inter";
          size = 13;
        };
        theme.dark = {
          name = "catppuccin-macchiato";
          icon_theme = "Adwaita";
        };
        launcher_window.opacity = 0.9;
        favorites = ["applications:org.gnome.Calculator"];
        providers = {
          browser-extension.enabled = false;
          clipboard.preferences = {
            monitoring = true;
            encryption = true;
            ignorePasswords = true;
          };
          core.enabled = false;
          developer.enabled = false;
          font = {
            enabled = true;
            entrypoints.browse.alias = "f";
          };
          manage-shortcuts.enabled = false;
          power.enabled = false;
          raycast-compat.enabled = false;
          scripts.enabled = false;
          system.enabled = false;
          theme.enabled = false;
        };
      };
    };
  };
}
