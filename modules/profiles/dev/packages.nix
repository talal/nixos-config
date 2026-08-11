{
  config,
  pkgs,
  ...
}: {
  # NOTE: don't install language packages (e.g. Go, Rust, etc.); use nix devshells instead.
  users.users.${config.user}.packages = with pkgs.unstable; [
    # keep-sorted start
    alejandra # nixfmt is yuck, alejandra is 👌
    bash-language-server
    devenv
    dprint
    exercism
    just-lsp
    keep-sorted
    marksman # Markdown LSP
    nixd
    nixfmt # for contributing to nixpkgs
    nixpkgs-review
    pi-coding-agent
    radicle-desktop
    radicle-node
    radicle-tui
    scc
    shellcheck
    shfmt
    skills
    superhtml
    taplo # TOML LSP
    tinymist
    treefmt
    typst
    typstyle
    uv # for Python scripts
    vscode-css-languageserver
    vscode-json-languageserver
    watchexec
    yaml-language-server
    yamlfmt
    zizmor
    # keep-sorted end
  ];
}
