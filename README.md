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

### Step 4: Bootstrap SOPS decryption using YubiKey

Plug in YubiKey, then export the age identity to the key file expected by `sops-nix`.

```bash
install -d -m 0700 /mnt/var/lib/sops-nix
age-plugin-yubikey --identity > /mnt/var/lib/sops-nix/key.txt
chmod 600 /mnt/var/lib/sops-nix/key.txt
```

### Step 5: Install

```bash
git add --intent-to-add --all
nixos-install --flake .#thinkpad
reboot
```

### Step 6: Rotate SOPS keys

After rebooting, generate new system/user keys and rotate SOPS recipients.

```bash
sudo install -d -m 0700 /var/lib/sops-nix
# age-keygen sets 0600 by default, no need to chmod
sudo age-keygen -o /var/lib/sops-nix/key.txt

install -d -m 0700 ~/.config/sops/age
age-keygen -o ~/.config/sops/age/key.txt
```

Update recipients in `.sops.yaml`.

```bash
# system public key
sudo age-keygen -y /var/lib/sops-nix/key.txt
# user public key
age-keygen -y ~/.config/sops/age/key.txt
```

Re-encrypt all secrets.

```bash
SOPS_AGE_KEY_CMD="age-plugin-yubikey --identity" sops updatekeys secrets/**
```

## Credits

Special thanks to all these people who made their Nix configs open-source which I learned and borrowed from:

- [max-baz](https://github.com/max-baz/dotfiles)
- [isabelroses](https://github.com/isabelroses/dotfiles)
- [pluie.me](https://tangled.org/pluie.me/flake)
- [Mic92](https://github.com/Mic92/dotfiles)
- [notashelf](https://github.com/notashelf)
- [getchoo](https://github.com/getchoo/borealis)
- [amaanq](https://github.com/amaanq/dotfiles)
