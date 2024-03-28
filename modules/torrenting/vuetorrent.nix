{ config, pkgs, lib, ... }:

let
  cfg = config.services.vuetorrent;
in
{
  options = {
    services.vuetorrent = {
      enable = lib.mkEnableOption (lib.mdDoc "vuetorrent");
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."vuetorrent" = {
      source = pkgs.vuetorrent;
      target = "vuetorrent";
    };
  };
}
