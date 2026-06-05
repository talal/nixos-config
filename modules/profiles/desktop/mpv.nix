{
  lib,
  pkgs,
  ...
}: {
  hm = {
    programs.mpv = {
      enable = true;
      config = {
        profile = "gpu-hq";
        gpu-api = "vulkan";
        gpu-context = "waylandvk";
        hwdec = "auto";
        vo = "gpu-next"; # https://github.com/mpv-player/mpv/wiki/GPU-Next-vs-GPU
        ao = "pipewire";

        border = false;
        osc = false;
        osd-bar = false;

        hr-seek = true;
        keep-open = true;
        reset-on-next-file = "video-zoom,panscan,video-unscaled,video-rotate,video-align-x,video-align-y";
        save-position-on-quit = true;
        save-watch-history = true;
        volume = 20;

        slang = "en,eng,de,deu,ger";
        alang = "ja,jp,jpn,de,deu,ger,en,eng"; # Onii-Chan!

        ytdl-format = "bestvideo[height<=?1080]+bestaudio/best";
        screenshot-dir = "~/Pictures/Screenshots/mpv";
      };

      scripts = with pkgs.mpvScripts; [modernz thumbfast mpris sponsorblock];
      scriptOpts = {
        thumbfast = {
          spawn_first = true;
          network = true;
          hwdec = true;
        };
        modernz = {
          osc_on_seek = false;
          osc_on_start = true;
          showonpause = false;
          window_top_bar = false;

          fullscreen_button = false;
          info_button = false;
          ontop_button = false;
          speed_button = true;

          hover_effect = "color";
          hover_effect_color = "#8aadf4";
          seekbarbg_color = "#1e2030";
          seekbarfg_color = "#8aadf4";
        };
        ytdl_hook = {
          ytdl_path = "${lib.getExe pkgs.unstable.yt-dlp}";
        };
      };

      bindings = {
        UP = "add volume 2";
        DOWN = "add volume -2";
        "Alt+LEFT" = "seek -60";
        "Alt+RIGHT" = "seek 60";
        V = "cycle secondary-sub-visibility";
        "Ctrl+j" = "cycle secondary-sid";
        "Ctrl+J" = "cycle secondary-sid down";
      };
    };
  };
}
