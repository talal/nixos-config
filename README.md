# nixos-config

> [!WARNING]
> Personal repository; not intended for general use.

## Fresh Install

Boot into a live graphical NixOS image, ensure network connection works, open a terminal and then follow the steps below.

### Step 1: Set up

```bash
sudo -i
```

```bash
nix-env -iA nixos.git
```

```bash
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
```

```bash
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/thinkpad-e16-g2/hardware-configuration.nix
```

> [!NOTE]
> `nixos-generate-config` doesn't capture btrfs mount options. Verify that the `mountOptions` for each subvolume in `hardware-configuration.nix` match those defined in `disko.nix` and add them manually if missing.

### Step 4: Install

```bash
git add --intent-to-add --all
```

```bash
nixos-install --flake .#thinkpad
```

```bash
reboot
```
