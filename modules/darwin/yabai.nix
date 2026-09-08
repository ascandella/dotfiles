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
      # Only use sudo if the current user is in the sudoers list, otherwise
      # fall back to calling yabai directly.
      if sudo -n true 2>/dev/null; then
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
      fi

      # Exclusions
      # https://github.com/koekeishiya/yabai/issues/2199#issuecomment-2031528636
      function yabai_rule {
        yabai -m rule --add "$@"
        yabai -m rule --apply "$@"
      }
      yabai_rule app="^System Settings$" manage=off sub-layer=below
      yabai_rule app="^Zoom$" manage=off sub-layer=below
      yabai_rule app="^Messages$" manage=off sub-layer=below
      yabai_rule app="^Todoist$" manage=off sub-layer=below
    '';
  };
}
