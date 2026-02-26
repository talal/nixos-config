{
  inputs,
  pkgs,
  ...
}: {
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
        inputs.starship-jj.packages.${pkgs.stdenv.hostPlatform.system}.default
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
        hunspell
        hunspellDicts.de_DE
        hunspellDicts.en_GB-ize
        hyperfine
        jq
        just
        p7zip
        poppler-utils
        procs
        scc
        scooter
        sd
        stow
        trash-cli
        watchexec
        wl-screenrec
        # keep-sorted end
      ])
      ++ (with pkgs.unstable; [
        # ══════════ Dev ══════════
        # keep-sorted start prefix_order=inputs,unstable
        inputs.flox.packages.${pkgs.stdenv.hostPlatform.system}.default
        # amp
        ast-grep
        devenv
        # gemini-cli
        # jjui
        jujutsu
        # lazyjj
        watchman # for jj fsmonitor
        yaak
        zed-editor
        # keep-sorted end

        # NOTE: do not install language related packages globally, use devenv or Flox instead.
        # Only install language servers, linters, and formatters for generic files (e.g. TOML, markdown, etc.)
        # so we can edit them even when outside a devenv/Flox environment.

        # keep-sorted start
        alejandra # nixfmt is yuck, alejandra is 👌
        bash-language-server
        just-lsp
        marksman # Markdown LSP
        mdformat
        # nil
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
