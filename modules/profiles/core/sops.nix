{inputs, ...}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/var/lib/sops-nix/key.txt"; # must have no password
  };

  hm = {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      defaultSopsFile = inputs.self + "/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      # The sops CLI has its own lookup rules and defaults to ~/.config/sops/age/keys.txt
      # therefore plural instead of singular 'key.txt' as filename.
      age.keyFile = "/home/talal/.config/sops/age/keys.txt"; # must have no password
    };
  };
}
