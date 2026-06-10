# nixos-config

Deterministic NixOS configuration for all my devices.

## Fresh Install

Boot into a live graphical NixOS image, ensure network connection works, open a terminal and then follow the steps below.

### Step 1: Set up

```bash
sudo -i
nix-env -iA nixos.git
git clone https://github.com/talal/nixos-config /tmp/nixos-config && cd /tmp/nixos-config
```

### Step 2: Partition and mount disks

> [!WARNING]
> The `destroy` mode will erase all data on the target disk. Double-check that the device path is correct before running this.

```bash
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./hosts/thinkpad-e16-g2/disko.nix --arg device '"/dev/nvme0n1"'
```

### Step 3: Generate hardware configuration

```bash
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/thinkpad-e16-g2/hardware-configuration.nix
```

> [!NOTE]
> `nixos-generate-config` doesn't capture btrfs mount options. Verify that the `mountOptions` for each subvolume in `hardware-configuration.nix` match those defined in `disko.nix` and add them manually if missing.

### Step 4: Generate SOPS keys

Since this is a fresh install, we need to pre-generate the age keys for the system and the user in the mounted filesystem so they can be added to SOPS before installation.

```bash
# Generate the system age key
install -d -m 0700 /mnt/var/lib/sops-nix
age-keygen -o /mnt/var/lib/sops-nix/key.txt

# Generate the user age key
install -d -m 0700 /mnt/home/talal/.config/sops/age
age-keygen -o /mnt/home/talal/.config/sops/age/keys.txt
chown -R 1000:100 /mnt/home/talal/.config
```

### Step 5: Add new keys to SOPS

Print the newly generated public keys:

```bash
age-keygen -y /mnt/var/lib/sops-nix/key.txt
age-keygen -y /mnt/home/talal/.config/sops/age/keys.txt
```

Open `.sops.yaml` in an editor and replace the `system` and `user` identities with the public keys printed above.

Plug in the YubiKey (to decrypt the existing secrets) and re-encrypt the files:

```bash
SOPS_AGE_KEY_CMD="age-plugin-yubikey --identity" sops updatekeys -y secrets/**
```

### Step 6: Install

```bash
export NIX_CONFIG="access-tokens = github.com=ghp_yourtoken"
git add --intent-to-add --all
nixos-install --flake .#thinkpad
reboot
```

## Credits

Special thanks to all these people who made their Nix configs open-source which I learned and borrowed from:

- [isabelroses](https://github.com/isabelroses/dotfiles)
- [pluie.me](https://tangled.org/pluie.me/flake)
- [max-baz](https://github.com/max-baz/dotfiles)
- [Mic92](https://github.com/Mic92/dotfiles)
- [ners](https://github.com/ners/trilby)
- [getchoo](https://github.com/getchoo/borealis)
- [amaanq](https://github.com/amaanq/dotfiles)
