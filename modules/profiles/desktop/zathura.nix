{
  hm = {
    programs.zathura = {
      enable = true;
      options = {
        adjust-open = "width";
        database = "sqlite";
        font = "monospace normal 12";
        incremental-search = true;
        scroll-full-overlap = 0.01;
        scroll-page-aware = true;
        scroll-step = 100;
        selection-notification = false;
      };
      mappings = {
        y = ''exec "sh -c 'wl-paste --primary | wl-copy'"'';
      };
    };
  };
}
