{ lib, config, ... }:

let
  cfg = config.services.aispace.frigate;
in
with lib;
{
  options.services.aispace.frigate = {
    enable = mkEnableOption (mdDoc "enable frigate via OCI container");
    version = mkOption {
      type = types.str;
      default = "0.14.0-tensorrt";
    };
    port = mkOption {
      type = types.int;
      default = 8971;
    };
    openFirewall = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    virtualisation.oci-containers.containers.frigate = {
      image = "ghcr.io/blakeblackshear/frigate:${cfg.version}";
      ports = [
        "${toString cfg.port}:8971"
        "8585:5000" # internal API, not exposed on network
        "8554:8554" # rtsp streaming for go2rtc, not exposed on network
      ];
      volumes = [
        "${config.my.nas.serverConfigDir}/frigate:/config"
        "${config.my.nas.frigateDir}:/media/frigate"
      ];
      extraOptions = [
        # Add GPU
        "--device"
        "nvidia.com/gpu=all"
      ];
    };
    systemd.services."${config.virtualisation.oci-containers.backend}-frigate" = {
      after = [
        "data-apps.mount"
        "data-frigate.mount"
      ];
    };
  };
}
