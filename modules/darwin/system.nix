{ lib, pkgs, ... }:
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    services.nix-daemon.enable = true;
  };
}
