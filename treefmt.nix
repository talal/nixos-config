{
  projectRootFile = "flake.nix";

  settings.global.excludes = [
    # Auto-generated files
    "**/hardware-configuration.nix"
    "config/DankMaterialShell/**"
    "config/vicinae/**"
    # Secrets
    "**/nextdns.conf"
    "config/DankMaterialShell/**"
    "config/espanso/match/**"
    "config/git/**"
    "config/jj/**"
    "config/pika-backup/**" # also auto-generated
    "config/ssh/**"
  ];

  # keep-sorted start block=yes newline_separated=yes
  programs = {
    # keep-sorted start
    alejandra.enable = true;
    deadnix.enable = true;
    fish_indent.enable = true;
    just.enable = true;
    keep-sorted.enable = true;
    statix.enable = true;
    yamlfmt.enable = true;
    # keep-sorted end
  };

  programs.mdformat = {
    enable = true;
    settings.number = true;
  };

  programs.prettier = {
    enable = true;
    includes = ["*.css" "*.json"];
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
  # keep-sorted end
}
