{
  config,
  pkgs,
  ...
}: {
  # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts.
  # For everything else, use nix devshells.
  users.users.${config.user}.packages = with pkgs.unstable; [
    (mdformat.withPlugins (
      p: [
        p.mdformat-footnote
        p.mdformat-frontmatter
        p.mdformat-gfm
        p.mdformat-mkdocs
        p.mdformat-simple-breaks
        p.mdformat-wikilink
      ]
    ))
    # keep-sorted start
    alejandra # nixfmt is yuck, alejandra is 👌
    bash-language-server
    devenv
    exercism
    just-lsp
    keep-sorted
    marksman # Markdown LSP
    nixd
    nixfmt # for contributing to nixpkgs
    nixpkgs-review
    prettier # JSON formatting
    scc
    shellcheck
    shfmt
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
