{
  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    permittedInsecurePackages = [
      # TODO: remove when bitwarden-deskop upgrades its electron version.
      "electron-39.8.10"
    ];
  };
}
