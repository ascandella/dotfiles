{ lib, pkgs, ... }:

{
  config = lib.mkIf pkgs.stdenv.isDarwin {

    homebrew = {
      enable = true;
      global = {
        autoUpdate = false;
      };
      brews = [
        # TODO what do we want to brew install?
      ];
      casks = [ "1password" ];
    };
  };
}
