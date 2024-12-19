{
  system,
  inputs,
  config,
  ...
}:

let
  zjstatus = ''
    pane size=1 borderless=true {
      plugin location="file:${inputs.zjstatus.packages.${system}.default}/bin/zjstatus.wasm" {
        // Catppuccin Mocha
        // https://github.com/merikan/.dotfiles/blob/85c941c03cc7fb0496a1482bdbd055fe34e016b0/config/zellij/themes/zjstatus/catppuccin.kdl
        color_rosewater "#f5e0dc"
        color_flamingo "#f2cdcd"
        color_pink "#f5c2e7"
        color_mauve "#cba6f7"
        color_red "#f38ba8"
        color_maroon "#eba0ac"
        color_peach "#fab387"
        color_yellow "#f9e2af"
        color_green "#a6e3a1"
        color_teal "#94e2d5"
        color_sky "#89dceb"
        color_sapphire "#74c7ec"
        color_blue "#89b4fa"
        color_lavender "#b4befe"
        color_text "#cdd6f4"
        color_subtext1 "#bac2de"
        color_subtext0 "#a6adc8"
        color_overlay2 "#9399b2"
        color_overlay1 "#7f849c"
        color_overlay0 "#6c7086"
        color_surface2 "#585b70"
        color_surface1 "#45475a"
        color_surface0 "#313244"
        color_base "#1e1e2e"
        color_mantle "#181825"
        color_crust "#11111b"

        format_left   "#[bg=$surface0]{mode}#[bg=$surface0] {tabs}"
        format_center "{notifications}"
        format_right  "#[bg=$surface0,fg=$maroon]#[bg=$maroon,fg=$crust]󰃭 #[bg=$surface1,fg=$maroon,bold] {datetime}#[bg=$surface0,fg=$surface1]"
        format_space  "#[bg=$surface0]"

        format_hide_on_overlength "true"
        format_precedence "lrc"

        border_enabled  "false"
        border_char     "─"
        border_format   "#[fg=#6C7086]{char}"
        border_position "top"

        hide_frame_for_single_pane       "false"
        hide_frame_except_for_search     "false"
        hide_frame_except_for_fullscreen "false"

        mode_normal        "#[bg=$green,fg=$crust,bold] NORMAL#[bg=$surface0,fg=$green]"
        mode_tmux          "#[bg=$mauve,fg=$crust,bold]  TMUX #[bg=$surface0,fg=$mauve]"
        mode_locked        "#[bg=$red,fg=$crust,bold] LOCKED#[bg=$surface0,fg=$red]"
        mode_pane          "#[bg=$teal,fg=$crust,bold]  PANE #[bg=$surface0,fg=teal]"
        mode_tab           "#[bg=$teal,fg=$crust,bold] TAB#[bg=$surface0,fg=$teal]"
        mode_scroll        "#[bg=$flamingo,fg=$crust,bold] SCROLL#[bg=$surface0,fg=$flamingo]"
        mode_enter_search  "#[bg=$flamingo,fg=$crust,bold] ENT-SEARCH#[bg=$surfaco,fg=$flamingo]"
        mode_search        "#[bg=$flamingo,fg=$crust,bold] SEARCHARCH#[bg=$surfac0,fg=$flamingo]"
        mode_resize        "#[bg=$yellow,fg=$crust,bold] RESIZE#[bg=$surfac0,fg=$yellow]"
        mode_rename_tab    "#[bg=$yellow,fg=$crust,bold] RENAME-TAB#[bg=$surface0,fg=$yellow]"
        mode_rename_pane   "#[bg=$yellow,fg=$crust,bold] RENAME-PANE#[bg=$surface0,fg=$yellow]"
        mode_move          "#[bg=$yellow,fg=$crust,bold] MOVE#[bg=$surface0,fg=$yellow]"
        mode_session       "#[bg=$pink,fg=$crust,bold] SESSION#[bg=$surface0,fg=$pink]"
        mode_prompt        "#[bg=$pink,fg=$crust,bold] PROMPT#[bg=$surface0,fg=$pink]"

        tab_normal              "#[bg=$surface0,fg=$blue]#[bg=$blue,fg=$crust,bold]{index} #[bg=$surface1,fg=$blue,bold] {name}{floating_indicator}#[bg=$surface0,fg=$surface1]"
        tab_normal_fullscreen   "#[bg=$surface0,fg=$blue]#[bg=$blue,fg=$crust,bold]{index} #[bg=$surface1,fg=$blue,bold] {name}{fullscreen_indicator}#[bg=$surface0,fg=$surface1]"
        tab_normal_sync         "#[bg=$surface0,fg=$blue]#[bg=$blue,fg=$crust,bold]{index} #[bg=$surface1,fg=$blue,bold] {name}{sync_indicator}#[bg=$surface0,fg=$surface1]"
        tab_active              "#[bg=$surface0,fg=$peach]#[bg=$peach,fg=$crust,bold]{index} #[bg=$surface1,fg=$peach,bold] {name}{floating_indicator}#[bg=$surface0,fg=$surface1]"
        tab_active_fullscreen   "#[bg=$surface0,fg=$peach]#[bg=$peach,fg=$crust,bold]{index} #[bg=$surface1,fg=$peach,bold] {name}{fullscreen_indicator}#[bg=$surface0,fg=$surface1]"
        tab_active_sync         "#[bg=$surface0,fg=$peach]#[bg=$peach,fg=$crust,bold]{index} #[bg=$surface1,fg=$peach,bold] {name}{sync_indicator}#[bg=$surface0,fg=$surface1]"
        tab_separator           "#[bg=$surface0] "

        tab_sync_indicator       " "
        tab_fullscreen_indicator " 󰊓"
        tab_floating_indicator   " 󰹙"

        command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
        command_git_branch_format      "#[fg=$blue] {stdout} "
        command_git_branch_interval    "10"
        command_git_branch_rendermode  "static"

        command_host_command    "uname -n"
        command_host_format     "{stdout}"
        command_host_interval   "0"
        command_host_rendermode "static"

        command_user_command    "whoami"
        command_user_format     "{stdout}"
        command_user_interval   "10"
        command_user_rendermode "static"

        datetime          "#[fg=$fg] {format} "
        datetime_format   "%Y-%m-%d %H:%M"
        datetime_timezone "America/Los_Angeles"
      }
    }

  '';
in
{
  xdg.configFile =
    {
      "zellij/layouts/default.kdl".text = ''
        pane_frames false
        theme "nord"
        layout {
            default_tab_template {
              children
              ${zjstatus}
            }
            tab
        }

      '';
      "zellij/layouts/vitally.kdl".text = ''
        layout {
          cwd "${config.home.homeDirectory}/src/vitally"
          default_tab_template {
              children
              ${zjstatus}
          }
          tab name="build" {
              pane {
                  command "zsh"
                  args "-i" "-c" "yarn build:watch"
              }
          }
          tab name="vim" {
              pane
          }
        }
      '';
      "zellij/layouts/vitally.swap.kdl".source = ./files/zellij/layouts/default.swap.kdl;
    }
    // builtins.listToAttrs (
      map
        (name: {
          name = "zellij/${name}";
          value = {
            source = ./files/zellij/${name};
          };
        })
        [
          "config.kdl"
          "layouts/default.swap.kdl"
        ]
    );
}
