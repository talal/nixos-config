{pkgs, ...}: {
  home-manager.users.talal = {
    home.packages =
      (with pkgs; [
        # ══════════ Applications ══════════
        # keep-sorted start prefix_order=unstable
        unstable.bitwarden-desktop
        unstable.discord
        unstable.ente-desktop
        unstable.obsidian
        blanket
        czkawka
        gimp
        gnome-calculator
        gnome-text-editor
        keepassxc
        libreoffice-still
        loupe
        nautilus
        papers
        parabolic
        pdfarranger
        pika-backup
        proton-authenticator
        resources
        signal-desktop
        yubioath-flutter
        zeal
        # keep-sorted end

        # ══════════ Utilities ══════════
        # keep-sorted start prefix_order=inputs,unstable
        unstable.amd-debug-tools
        unstable.snitch # TODO: not available in nixos-25.11 therefore using nixpkgs-unstable
        choose
        delta
        difftastic
        duf
        dust
        exiftool
        ffmpeg-full
        fzf
        gh
        git-cliff
        git-crypt
        git-filter-repo
        hexyl
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_GB-ize
        hyperfine
        jq
        just
        p7zip
        pciutils
        poppler-utils
        powertop
        procs
        scc
        scooter
        sd
        stow
        trash-cli
        usbutils
        watchexec
        wl-screenrec
        # keep-sorted end
      ])
      ++ (with pkgs.unstable; [
        # ══════════ Dev ══════════
        # keep-sorted start prefix_order=inputs,unstable
        ast-grep
        devenv
        jj-starship
        jujutsu
        watchman # for jj fsmonitor
        yaak
        zed-editor
        # keep-sorted end

        # NOTE: do not install language related packages globally, use devenv instead.
        # Only install language servers, linters, and formatters for generic files (e.g. TOML, markdown, etc.)
        # so we can edit them even when outside a devenv environment.

        # keep-sorted start
        alejandra # nixfmt is yuck, alejandra is 👌
        bash-language-server
        just-lsp
        marksman # Markdown LSP
        mdformat
        nixd
        prettier # JSON formatting
        shellcheck
        shfmt
        taplo # TOML LSP
        tinymist
        treefmt
        typst # I use Typst alot so installing globally instead of devenv
        typstyle
        uv # needed for scripts: `#!/usr/bin/env -S uv run --script`
        vscode-json-languageserver
        yaml-language-server
        yamlfmt
        # keep-sorted end
      ]);
  };
}
