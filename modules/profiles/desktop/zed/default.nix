{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.unstable.zed-editor
  ];

  hm = {config, ...}: {
    xdg.configFile."zed" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/profiles/desktop/zed/config";
      recursive = true;
    };
  };
}
