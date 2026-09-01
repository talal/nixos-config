{...}: {
  hm = {
    programs.television = {
      enable = true;
      settings = {
        ui.theme = "alabaster-dark";

        shell_integration.channel_triggers = {
          dirs = ["cd" "tree" "ls" "ll" "eza"];
          env = ["export" "unset"];
          git-diff = ["git add" "git restore"];
          git-log = ["git log" "git show"];
        };
      };
    };

    xdg.configFile."television/themes/alabaster-dark.toml".text = ''
      # name: Alabaster Dark
      # https://github.com/tonsky/sublime-scheme-alabaster (original scheme)

      # general
      background = '#0e1415'
      border_fg = '#708b8d'
      text_fg = '#cecece'
      dimmed_text_fg = '#708b8d'

      # input
      input_text_fg = '#cd974b'
      result_count_fg = '#cd974b'

      # results
      result_name_fg = '#cecece' # alternative: #71ade7
      result_line_number_fg = '#708b8d'
      result_value_fg = '#95cb82'
      selection_fg = '#cd974b'
      selection_bg = '#3d5457'
      match_fg = '#cd974b'

      # preview
      preview_title_fg = '#ec8013'

      # modes
      channel_mode_fg = '#0e1415'
      channel_mode_bg = '#cd974b'
      remote_control_mode_fg = '#0e1415'
      remote_control_mode_bg = '#95cb82'
      send_to_channel_mode_fg = '#71ade7'
    '';
  };
}
