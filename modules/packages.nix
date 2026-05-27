{
  inputs,
  pkgs,
  ...
}: {
  # keep-sorted start block=yes newline_separated=yes prefix_order=environment
  environment.systemPackages =
    (with pkgs; [
      # keep-sorted start prefix_order=unstable
      unstable.snitch # TODO: not available in nixos-25.11 therefore using nixpkgs-unstable
      age
      choose
      difftastic
      doggo
      duf
      dust
      exiftool
      ffmpeg-full
      fzf
      glow
      hyperfine
      jq
      just
      moor
      p7zip
      pciutils
      poppler-utils # for yazi
      procs
      scc
      scooter
      sd
      sops
      trash-cli
      tree
      usbutils
      watchexec
      wl-clipboard
      # keep-sorted end
    ])
    ++ (with pkgs.unstable; [
      # ══════════ Dev ═════════
      # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts.
      # For everything else, use devenv.

      # keep-sorted start
      alejandra # nixfmt is yuck, alejandra is 👌
      bash-language-server
      devenv
      exercism
      just-lsp
      keep-sorted
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
      zizmor
      # keep-sorted end
    ])
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      antigravity
      gemini-cli
      pi
      semble
    ]);
  # keep-sorted end
}
