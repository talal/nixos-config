flake := justfile_directory()

alias rs := switch

[private]
default:
    @just --list

# test the new system configuration without setting it as boot default
test *args:
    sudo nixos-rebuild test --flake {{ flake }} {{ args }}

# switch to the new system configuration
switch *args:
    sudo nixos-rebuild switch --flake {{ flake }} {{ args }}

# update a set of given inputs
update *input:
    nix flake update {{ input }} --refresh --flake {{ flake }}

# check the flake for errors
check *args:
    nix flake check --option allow-import-from-derivation false {{ args }}

# clean the nix store and optimise it
clean:
    sudo nix-collect-garbage --delete-older-than 3d
    sudo nix store optimise

[private]
setup-flatpak:
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
