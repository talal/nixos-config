_: {
  hm = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        load_dotenv = false;
        strict_env = true;
        warn_timeout = 0;
      };
      # store direnv in cache and not per project
      # Reference: https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories
      stdlib = ''
        : ''${XDG_CACHE_HOME:=$HOME/.cache}
        declare -A direnv_layout_dirs

        direnv_layout_dir() {
          echo "''${direnv_layout_dirs[$PWD]:=$(
            echo -n "$XDG_CACHE_HOME"/direnv/layouts/
            echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
          )}"
        }
      '';
    };
  };
}
