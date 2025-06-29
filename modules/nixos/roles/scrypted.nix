{ lib, config, ... }:

let
  cfg = config.services.aispace.scrypted;
in
with lib;
{
  options.services.aispace.scrypted = {
    enable = mkEnableOption (mdDoc "enable scrypted via OCI container");
    version = mkOption {
      type = types.str;
      default = "v0.139.0-noble-full";
    };
    port = mkOption {
      type = types.int;
      default = 10443;
    };
    dataDir = mkOption {
      type = types.str;
      default = "${config.my.nas.serverConfigDir}/scrypted";
      description = "scrypted configuration directory";
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.port
        40977 # avahi
        48357 # driveway bridge port
      ];
    };

    virtualisation.oci-containers.containers.scrypted = {
      image = "ghcr.io/koush/scrypted:${cfg.version}";
      environment = {
        # We're not running avahi on the host
        SCRYPTED_DOCKER_AVAHI = "true";
      };
      volumes = [ "${cfg.dataDir}:/server/volume" ];
      extraOptions = [ "--network=host" ];
    };
    systemd.services."${config.virtualisation.oci-containers.backend}-scrypted" = {
      after = [ "data-apps.mount" ];
    };
  };
}
