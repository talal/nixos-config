{
  hm = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config = {
        disable_stdin = true;
        load_dotenv = false;
        strict_env = true;
        warn_timeout = 0;
      };
      # Store direnv cache in ~/.cache instead of per project.
      # Reference: https://github.com/direnv/direnv/wiki/Customizing-cache-location#hashed-directories
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
          local hash path
          echo "''${direnv_layout_dirs[$PWD]:=$(
            hash="$(sha1sum - <<< "$PWD" | head -c40)"
            path="''${PWD//[^a-zA-Z0-9]/-}"
            echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
          )}"
        }
      '';
    };
  };
}
