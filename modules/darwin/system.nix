{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services.nix-daemon.enable = true;

    # Reference: https://github.com/nmasur/dotfiles/blob/c697cd4e383997cdd45e6e4b76cc95d195efd6e0/modules/darwin/system.nix
    system = {
      defaults = {
        NSGlobalDomain = {
          # Set to dark mode
          AppleInterfaceStyle = "Dark";

          # Set a fast key repeat rate
          KeyRepeat = 2;

          # Shorten delay before key repeat begins
          InitialKeyRepeat = 12;
        };

        # Disable "Are you sure you want to open" dialog
        LaunchServices.LSQuarantine = false;

        dock = {
          # Automatically show and hide the dock
          autohide = true;
        };
      };
    };
  };
}
