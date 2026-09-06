{
  hm = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "TX\\-02:size=14, Symbols Nerd Font:size=14";
          underline-offset = 3;
          pad = "6x0 center";
        };
        mouse.hide-when-typing = "yes";
        colors-dark = {
          alpha = 0.90;
          blur = true;

          # Alabaster theme
          cursor = "0e1415 cd974b";
          foreground = "cecece";
          background = "0e1415";

          regular0 = "000000";
          regular1 = "e25d56";
          regular2 = "73ca50";
          regular3 = "e9bf57";
          regular4 = "4a88e4";
          regular5 = "915caf";
          regular6 = "23acdd";
          regular7 = "cecece";

          bright0 = "777777";
          bright1 = "f36868";
          bright2 = "88db3f";
          bright3 = "f0bf7a";
          bright4 = "6f8fdb";
          bright5 = "e987e9";
          bright6 = "4ac9e2";
          bright7 = "ffffff";

          # attribute names can't start with digits so need to quote
          "16" = "ec8013";
          "17" = "cd974b";

          selection-foreground = "cecece";
          selection-background = "3d5457";

          search-box-no-match = "0e1415 cc3333";
          search-box-match = "cecece 3d5457";

          jump-labels = "0e1415 ec8013";
          urls = "71ade7";
        };
      };
    };
  };
}
