# nixos-config

> [!WARNING]
> Personal repository; not intended for general use.

## Installation

Boot into a live graphical NixOS image, ensure network connection works, open a terminal and then follow the steps down below.

### Step 1: Set up

```bash
sudo -i
```

```bash
nix-env -iA nixos.git
```

```bash
git clone https://github.com/talal/nixos-config /tmp/nix-config && cd /tmp/nix-config
```

### Step 2: Use Disko to partition and mount

```bash
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./system/disko.nix --arg device '"/dev/nvme0n1"'
```

### Step 3: Generate hardware configuration

```bash
nixos-generate-config --root /mnt
```

```bash
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/<host>/hardware-configuration.nix
```

`nixos-generate-config` doesn't capture btrfs mount options, so add them manually.

Verify that `filesystems.<partition>.mountOptions` in `hardware-configuration.nix` match what we'd expect (see `disk-config.nix`).

### Step 4: Install

```bash
git add --intent-to-add --all
```

```bash
nixos-install --flake .#<hostname>
```

```bash
reboot
```

```bash
just stow
```
