{lib, ...}: {
  hm = {
    programs.starship = {
      enable = true;
      enableTransience = true;
      settings = {
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$shlvl"
          "$directory"
          "\${custom.vcs}"
          "$nix_shell"
          "$direnv"
          "$python"
          "$docker_context"
          "$sudo"
          "$cmd_duration"
          "$fill" # fill needed to push $shell to the right side of prompt line
          "$shell"
          "$line_break"
          "$jobs"
          "$battery"
          "$os"
          "$container"
          "\${env_var.ZMX_SESSION}"
          "$character"
        ];
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[✗](bold red)";
        };
        cmd_duration.min_time = 120000;
        directory = {
          truncation_length = 8;
          style = "bold lavender";
        };
        env_var.ZMX_SESSION = {
          description = "zmx session name";
          format = "[$env_value]($style) ";
          style = "bold red";
        };
        custom.vcs = {
          when = "jj-starship detect";
          shell = ["jj-starship" "--no-symbol" "--no-jj-prefix" "--no-git-prefix"];
          format = "$output ";
        };
        nix_shell = {
          format = "[$state( $name)]($style) ";
          impure_msg = "[ ](bold blue)";
          pure_msg = "[ ](bold green)";
          unknown_msg = "[ ](bold red)";
        };
        direnv = {
          disabled = false;
          symbol = " ";
        };
        python = {
          format = "[($symbol$virtualenv)](bold green) ";
          symbol = "  ";
        };
        fill.symbol = " ";
        shell = {
          disabled = false;
          format = " [$indicator](bold white)";
          bash_indicator = "bash";
          fish_indicator = "";
        };
      };
    };
  };
}
