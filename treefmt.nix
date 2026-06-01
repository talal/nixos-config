{
  projectRootFile = "flake.nix";

  settings.global.excludes = [
    # Auto-generated files
    "**/hardware-configuration.nix"
    # Secrets
    "secrets/**"
  ];

  # keep-sorted start block=yes newline_separated=yes
  programs = {
    # keep-sorted start
    alejandra.enable = true;
    deadnix.enable = true;
    just.enable = true;
    keep-sorted.enable = true;
    statix.enable = true;
    yamlfmt.enable = true;
    zizmor.enable = true;
    # keep-sorted end
  };

  programs.mdformat = {
    enable = true;
    settings.number = true;
  };

  programs.prettier = {
    enable = true;
    includes = ["*.json"];
  };

  programs.taplo = {
    enable = true;
    settings.formatting = {
      align_comments = false;
      column_width = 100;
      inline_table_expand = false;
    };
  };

  programs.typos = {
    enable = true;
    includes = ["*.md"];
  };

  settings.formatter = {
    # Run Alejandra after deadnix
    alejandra.priority = 2;
    deadnix.priority = 1;
  };
  # keep-sorted end
}
