{
  config,
  lib,
  pkgs,
  ...
}: let
  vicinae = pkgs.unstable.vicinae; # base derivation
  # Override the base derivation to use our wrapper for the input server.
  vicinaePkg = vicinae.overrideAttrs (old: {
    postFixup =
      (old.postFixup or "")
      + ''
        wrapProgram $out/bin/vicinae \
          --set VICINAE_INPUT_SERVER_BIN "${config.security.wrapperDir}/vicinae-input-server"
      '';
  });
in {
  environment.systemPackages = [vicinaePkg];

  # Create a security wrapper to give the input server the permissions it needs.
  security.wrappers.vicinae-input-server = {
    source = "${vicinae}/libexec/vicinae/vicinae-input-server";
    capabilities = "cap_dac_override+ep";
    owner = "root";
    group = "root";
  };

  services.udev.extraRules = ''
    # Allows vicinae to create a virtual keyboard: required for paste support (the current user needs to be in the 'input' group)
    KERNEL=="uinput", GROUP="input", MODE="0660", RUN+="${pkgs.acl}/bin/setfacl -m g:input:rw /dev/$name"
  '';
  users.users.${config.user}.extraGroups = ["input"];

  hm = {
    xdg.configFile."vicinae/user_settings.json".text = lib.generators.toJSON {} {
      pop_to_root_on_close = true;
      font.normal = {
        family = "Inter";
        size = 13;
      };
      theme.dark = {
        name = "catppuccin-macchiato";
        icon_theme = "Adwaita";
      };
      launcher_window = {
        opacity = 0.9;
        layer_shell.layer = "overlay";
      };
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
}
