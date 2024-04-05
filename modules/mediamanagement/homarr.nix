{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.aispace.homarr;
in
{
  options = with lib; {
    services.aispace.homarr = {
      enable = mkEnableOption (mdDoc "Homarr");
      version = mkOption {
        type = types.str;
        default = "0.15.2";
        description = "The version of the Homarr image to use";
      };
      port = mkOption {
        type = types.port;
        default = 7575;
        description = "The port on which Homarr will listen";
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to open the firewall for the Homarr port";
      };
      configDir = mkOption {
        type = types.str;
        description = "Path to mount to /app/data/configs";
      };
      dataDir = mkOption {
        type = types.str;
        description = "Path to mount to /data";
      };
      iconsDir = mkOption {
        type = types.str;
        description = "Path to mount to /app/public/icons";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.homarr = {
      image = "ghcr.io/ajnart/homarr:${cfg.version}";
      ports = [ "${toString cfg.port}:7575" ];
      volumes = [
        "${cfg.dataDir}:/data"
        "${cfg.configDir}:/app/data/configs"
        "${cfg.iconsDir}:/app/public/icons"
      ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
