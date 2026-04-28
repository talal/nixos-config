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
        git-cliff
        git-crypt
        git-filter-repo
        glow
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
      # ══════════ Dev ══════════
      ++ (with pkgs.unstable; [
        # keep-sorted start prefix_order=inputs,unstable
        ast-grep
        devenv
        jj-starship
        jujutsu
        watchman # for jj fsmonitor
        yaak
        zed-editor
        # keep-sorted end

        # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts
        # globally. For everything else, use devenv.

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
        superhtml
        taplo # TOML LSP
        tinymist
        treefmt
        typst # I use Typst alot so installing globally instead of devenv
        typstyle
        uv # for Python scripts
        vscode-css-languageserver
        vscode-json-languageserver
        yaml-language-server
        yamlfmt
        # keep-sorted end
      ]);
  };
}
