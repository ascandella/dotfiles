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
        // Nord theme
        color_fg "#616e88" //= Brightest + 10% - "#4C566A" = Brightest - "#434C5E" = Bright
        color_bg "#2E3440"
        color_black "#3B4252"
        color_red "#BF616A"
        color_green "#A3BE8C"
        color_yellow "#EBCB8B"
        color_blue "#81A1C1"
        color_magenta "#B48EAD"
        color_cyan "#88C0D0"
        color_white "#E5E9F0"
        color_orange "#D08770"

        format_left   "{mode}#[bg=$bg] {tabs}"
        format_center "#[bg=$bg,fg=$fg] Zellij: #[bg=$bg,fg=$fg]{session}"
        format_right  "{command_git_branch} {datetime}"
        format_space  "#[bg=$bg]"
        format_hide_on_overlength "true"
        format_precedence "lrc"

        border_enabled  "false"
        border_char     "─"
        border_format   "#[fg=#6C7086]{char}"
        border_position "top"


        hide_frame_for_single_pane       "false"
        hide_frame_except_for_search     "false"
        hide_frame_except_for_fullscreen "false"


        mode_normal        "#[bg=$green,fg=$bg,bold] NORMAL#[bg=$bg,fg=$green]"
        mode_locked        "#[bg=$red,fg=$bg,bold] LOCKED #[bg=$bg,fg=$red]"
        mode_resize        "#[bg=$blue,fg=$bg,bold] RESIZE#[bg=$bg,fg=$blue]"
        mode_pane          "#[bg=$blue,fg=$bg,bold] PANE#[bg=$bg,fg=$blue]"
        mode_tab           "#[bg=$yellow,fg=$bg,bold] TAB#[bg=$bg,fg=$yellow]"
        mode_scroll        "#[bg=$blue,fg=$bg,bold] SCROLL#[bg=$bg,fg=$blue]"
        mode_enter_search  "#[bg=$orange,fg=$bg,bold] ENT-SEARCH#[bg=$bg,fg=$orange]"
        mode_search        "#[bg=$orange,fg=$bg,bold] SEARCHARCH#[bg=$bg,fg=$orange]"
        mode_rename_tab    "#[bg=$yellow,fg=$bg,bold] RENAME-TAB#[bg=$bg,fg=$yellow]"
        mode_rename_pane   "#[bg=$blue,fg=$bg,bold] RENAME-PANE#[bg=$bg,fg=$blue]"
        mode_session       "#[bg=$blue,fg=$bg,bold] SESSION#[bg=$bg,fg=$blue]"
        mode_move          "#[bg=$blue,fg=$bg,bold] MOVE#[bg=$bg,fg=$blue]"
        mode_prompt        "#[bg=$blue,fg=$bg,bold] PROMPT#[bg=$bg,fg=$blue]"
        mode_tmux          "#[bg=$magenta,fg=$bg,bold] TMUX#[bg=$bg,fg=$magenta]"

        // formatting for inactive tabs
        tab_normal              "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{floating_indicator} #[bg=$cyan,fg=$bg] #[bg=$bg,fg=$cyan,bold]"
        tab_normal_fullscreen   "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{fullscreen_indicator} #[bg=$cyan,fg=$bg] #[bg=$bg,fg=$cyan,bold]"
        tab_normal_sync         "#[bg=$bg,fg=$cyan]#[bg=$cyan,fg=$bg,bold]{index} #[bg=$bg,fg=$cyan,bold] {name}{sync_indicator} #[bg=$cyan,fg=$bg] #[bg=$bg,fg=$cyan,bold]"

        // formatting for the current active tab
        tab_active              "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{floating_indicator} #[bg=$yellow,fg=$bg,bold] #[bg=$bg,fg=$yellow,bold]"
        tab_active_fullscreen   "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{fullscreen_indicator} #[bg=$yellow,fg=$bg,bold] #[bg=$bg,fg=$yellow,bold]"
        tab_active_sync         "#[bg=$bg,fg=$yellow]#[bg=$yellow,fg=$bg,bold]{index} #[bg=$bg,fg=$yellow,bold] {name}{sync_indicator} #[bg=$yellow,fg=$bg,bold] #[bg=$bg,fg=$yellow,bold]"

        notification_format_unread           "#[fg=#89B4FA,bg=#181825,blink]  #[fg=#89B4FA,bg=#181825] {message} "
        notification_format_no_notifications "#[fg=#89B4FA,bg=#181825,dim]   "
        notification_show_interval           "10"
        // separator between the tabs
        tab_separator           "#[bg=$bg,fg=$bg] "

        // indicators
        tab_sync_indicator       " "
        tab_fullscreen_indicator " 󰊓"
        tab_floating_indicator   " 󰹙"

        command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
        command_git_branch_format      "#[fg=$blue] {stdout} "
        command_git_branch_interval    "10"
        command_git_branch_rendermode  "static"

        datetime        "#[fg=$fg] {format} "
        datetime_format "%Y-%m-%d %H:%M"
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
