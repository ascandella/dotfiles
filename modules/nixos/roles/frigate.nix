{
  lib,
  config,
  pkgs,
  ...
}:

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
    dataDir = mkOption {
      type = types.str;
      default = "${config.my.nas.serverConfigDir}/frigate";
      description = "Frigate configuration directory";
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
      environment = {
        # HACK ALERT: See below for manually mounting cudnn/libcublas
        LD_LIBRARY_PATH = "/usr/lib";
      };
      ports = [
        "${toString cfg.port}:8971"
        "127.0.0.1:8585:5000" # internal API, not exposed through firewall, only for home-assistant
        "127.0.0.1:8554:8554" # rtsp streaming for go2rtc, not exposed through firewall, only for home-assistant
      ];
      volumes =
        [
          "${cfg.dataDir}:/config"
          "${config.my.nas.frigateDir}:/media/frigate"
          # Make sure this is the same as what's in system configuration
          "${config.hardware.nvidia.package}/lib/libcuda.so:/usr/lib/libcuda.so:ro"
        ]
        ++ map (soFile: "${lib.getLib pkgs.cudaPackages_11.cuda_nvrtc}/lib/${soFile}:/usr/lib/${soFile}:ro")
          [
            "libnvrtc.so"
          ]
        ++
          map (soFile: "${lib.getLib pkgs.cudaPackages_11.cudnn_8_9}/lib/${soFile}:/usr/lib/${soFile}:ro")
            [
              "libcudnn_cnn_infer.so.8"
              "libcudnn_ops_infer.so.8"
            ]
        ++
          map (soFile: "${lib.getLib pkgs.cudaPackages_11.libcublas}/lib/${soFile}:/usr/lib/${soFile}:ro")
            [
              "libcublas.so"
              "libcublasLt.so"
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
