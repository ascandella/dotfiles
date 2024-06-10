{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {

    homebrew = {
      enable = true;
      global = {
        autoUpdate = false;
      };
      taps = [
        "FelixKratz/formulae" # for sketchybar
      ];
      brews = [ "sketchybar" ];
      casks = [ "1password" ];
    };
  };
}
