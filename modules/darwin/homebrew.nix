{ lib, pkgs, ... }:

{
  homebrew = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    global = {
      autoUpdate = false;
    };
    brews = [
      # TODO what do we want to brew install?
    ];
  };
}
