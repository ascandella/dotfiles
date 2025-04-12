{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    nix = {
      enable = true;
    };

    # Reference: https://github.com/nmasur/dotfiles/blob/c697cd4e383997cdd45e6e4b76cc95d195efd6e0/modules/darwin/system.nix
    system = {
      defaults = {
        trackpad = {
          TrackpadRightClick = true;
        };
        screencapture = {
          location = "~/Documents/Nextcloud/Screenshots";
        };

        NSGlobalDomain = {
          # Set to dark mode
          AppleInterfaceStyle = "Dark";

          # Set a fast key repeat rate
          KeyRepeat = 2;

          # Shorten delay before key repeat begins
          InitialKeyRepeat = 12;

          # Disable double-space for period
          NSAutomaticPeriodSubstitutionEnabled = false;
        };

        # Disable "Are you sure you want to open" dialog
        LaunchServices.LSQuarantine = false;

        dock = {
          # Automatically show and hide the dock
          autohide = true;
          # Don't rearrange spaces based on recently used
          mru-spaces = false;
          orientation = "left";
        };
      };

      activationScripts.postActivation.text = ''
        # Not an option in nix-darwin (yet)
        echo "Disabling standard click to show desktop..."
        defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
      '';
    };

    security.pam.services.sudo_local.touchIdAuth = true;
  };
}
