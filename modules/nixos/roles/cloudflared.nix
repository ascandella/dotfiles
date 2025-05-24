{ config, lib, ... }:

let
  cfg = config.services.aispace.cloudflared;
in
{
  options = {
    services.aispace.cloudflared = {
      enable = lib.mkEnableOption "Cloudflared service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cloudflared = {
      tunnels = {
        homelab = {
          default = "http_status:404";
        };
      };
    };
  };
}
