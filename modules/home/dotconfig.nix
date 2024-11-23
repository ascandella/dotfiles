{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}:
{
  xdg.configFile =
    let
      zjstatus = ''
        plugin location="${inputs.zjstatus.packages.${system}.default}/bin/zjstatus.wasm" {
            format_left   "{mode} #[fg=#89B4FA,bold]{session}"
            format_center "{tabs}"
            format_right  "{command_git_branch} {datetime}"
            format_space  ""

            border_enabled  "false"
            border_char     "─"
            border_format   "#[fg=#6C7086]{char}"
            border_position "top"

            hide_frame_for_single_pane "true"

            mode_normal  "#[bg=blue] "
            mode_tmux    "#[bg=#ffc387] "

            tab_normal   "#[fg=#6C7086] {name} "
            tab_active   "#[fg=#9399B2,bold,italic] {name} "

            command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
            command_git_branch_format      "#[fg=blue] {stdout} "
            command_git_branch_interval    "10"
            command_git_branch_rendermode  "static"

            datetime        "#[fg=#6C7086,bold] {format} "
            datetime_format "%A, %d %b %Y %H:%M"
            datetime_timezone "Europe/Berlin"
        }
      '';
    in
    {
      "efm-langserver".source = ./files/efm-langserver;
      "selene".source = ./files/selene;
      "skhd".source = ./files/skhd;
      "stylua".source = ./files/stylua;
      "wezterm".source = ./files/wezterm;
      "yabai".source = ./files/yabai;
      "yazi".source = ./files/yazi;
      "nvim/lua/ai/nix/tools.lua".text = ''
        vim.g.sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'

        return {
          gcc = '${lib.getExe pkgs.gcc}';
        }
      '';
      "nvim/lazy-lock.json".source = config.lib.file.mkOutOfStoreSymlink "${config.my.configDir}/modules/home/files/nvim/lazy-lock.json";
      "nvim" = {
        recursive = true;
        source = ./files/nvim/config;
      };
      "zellij/layouts/default.kdl".text = ''
        layout {
            pane
            default_tab_template {
              children
              pane size=1 borderless=true {
                ${zjstatus}
              }
            }
        }
      '';
      "zellij".source = ./files/zellij;
    };

  home.file = {
    ".npmrc".text = ''
      update-notifier=false
    '';
  };
}
