_: {
  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10" # EOL but still used by bitwarden-desktop
    ];
  };
}
