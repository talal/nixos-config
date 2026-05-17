flake := justfile_directory()

alias rs := switch

[private]
default:
    @just --list

[group('rebuild')]
[private]
builder goal prefix *args:
    {{ prefix }} nixos-rebuild {{ goal }} \
      --flake {{ flake }} \
      {{ args }}

# test what happens when you switch
[group('rebuild')]
test *args: (builder "test" "" args)

# switch to the new system configuration
[group('rebuild')]
switch *args: (builder "switch" "sudo" args)
    # TODO: temporary fix for GTK shenanigans
    @echo '@import url("dank-colors.css");' > ~/.config/gtk-4.0/gtk.css

# update a set of given inputs
[group('dev')]
update *input:
    nix flake update {{ input }} \
      --refresh \
      --flake {{ flake }}

# check the flake for errors
[group('dev')]
check *args:
    nix flake check --option allow-import-from-derivation false {{ args }}

# clean the nix store and optimise it
[group('utils')]
clean:
    sudo nix-collect-garbage --delete-older-than 7d
    sudo nix store optimise

[group('utils')]
setup-flatpak:
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak remote-add --user --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo
