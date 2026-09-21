{
  nixpkgs.config = {
    allowAliases = false;
    allowUnfree = true;
    permittedInsecurePackages = [
      # "electron-41.10.6"
      "radicle-node-1.10.3"
    ];
  };
}
