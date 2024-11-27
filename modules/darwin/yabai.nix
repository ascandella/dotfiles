_:

{
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {

      layout = "bsp";

      top_padding = "15";
      bottom_padding = "15";
      left_padding = "15";
      right_padding = "15";
      window_gap = "15";

      external_bar = "all:38:0";

      mouse_modifier = "ctrl";

      mouse_action1 = "resize";
      mouse_action2 = "move";

      # yabai -m space 1 --label main
      # yabai -m space 2 --label docs
      # yabai -m space 3 --label comms

      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.9";
    };
    extraConfig = ''
      # Not sure why this is necessary, but running it without sudo doesn't
      # load the scripting additions and makes workspace switching not work
      sudo yabai --load-sa

      # Exclusions
      # https://github.com/koekeishiya/yabai/issues/2199#issuecomment-2031528636
      function yabai_rule {
        yabai -m rule --add "$@"
        yabai -m rule --apply "$@"
      }
      yabai_rule app="^System Settings$" manage=off sub-layer=below
      yabai_rule app="^zoom.us" manage=off sub-layer=below
      yabai_rule app="^Messages$" manage=off sub-layer=below
      yabai_rule app="^Todoist$" manage=off sub-layer=below

      # refresh my Übersicht bar when the space changes
      yabai -m signal --add event=space_changed \
        action="osascript -e 'tell application id \"tracesOf.Uebersicht\" to refresh widget id \"simple-bar-index-jsx\"'"

      # disable ubersicht on fullscreen (work around wezterm issue)
      # yabai -m signal --add event=space_changed \
      #   action='
      #   hide_bar="false"
      #   if [ $(yabai -m query --windows --space | jq -e "map(select(.\"is-native-fullscreen\" == true)) | length > 0") = "true" ]; then
      #     hide_bar="true"
      #   fi
      #   osascript -e "tell application id \"tracesOf.Uebersicht\" to set hidden of widget id \"simple-bar-index-jsx\" to ''${hide_bar}"
      #   '
    '';
  };
}
