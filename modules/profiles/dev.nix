{
  inputs,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: {
  # NOTE: only install packages for common files (JSON, TOML, etc.) and scripts.
  # For everything else, use devenv.
  users.users.${config.user}.packages =
    (with pkgs-unstable; [
      # keep-sorted start
      alejandra # nixfmt is yuck, alejandra is 👌
      bash-language-server
      choose
      devenv
      exercism
      just-lsp
      keep-sorted
      marksman # Markdown LSP
      mdformat
      nixd
      prettier # JSON formatting
      scc
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
      watchexec
      yaml-language-server
      yamlfmt
      zizmor
      # keep-sorted end
    ])
    ++ (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      antigravity-cli
      gemini-cli
      nono
      pi
      semble
    ]);
}
