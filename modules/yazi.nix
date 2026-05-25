{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    poppler-utils
  ];

  home-manager.users.${config.user} = {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      settings.mgr.show_hidden = true;

      plugins = with pkgs; {
        inherit (yaziPlugins) chmod full-border jump-to-char smart-enter toggle-pane;
        folder-rules = writeTextDir "main.lua" ''
          local function setup()
            ps.sub("cd", function()
              local cwd = cx.active.current.cwd
              if cwd:ends_with("Downloads") then
                ya.emit("sort", { "mtime", reverse = true, dir_first = false })
              else
                ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
              end
            end)
          end
          return { setup = setup }
        '';
      };

      initLua = ''
        require("full-border"):setup()
        require("folder-rules"):setup()
      '';

      keymap.mgr = {
        prepend_keymap = [
          {
            on = "f";
            run = "plugin jump-to-char";
            desc = "Jump to char";
          }
          {
            on = "l";
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
          {
            on = ["c" "m"];
            run = "plugin chmod";
            desc = "chmod on selected files";
          }
          {
            on = "<C-1>";
            run = "plugin toggle-pane max-parent";
            desc = "Maximize or restore the parent pane";
          }
          {
            on = "<C-2>";
            run = "plugin toggle-pane max-current";
            desc = "Maximize or restore the current pane";
          }
          {
            on = "<C-3>";
            run = "plugin toggle-pane max-preview";
            desc = "Maximize or restore the preview pane";
          }
        ];

        append_keymap = [
          {
            on = ["g" "."];
            run = "cd ~/.dotfiles";
            desc = "Go ~/.dotfiles";
          }
          {
            on = ["g" "r"];
            run = ''shell -- ya emit cd "$(git root)"'';
            desc = "cd back to the root of the current Git repository";
          }
        ];
      };
    };
  };
}
