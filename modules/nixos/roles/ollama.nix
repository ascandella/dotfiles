{ lib, config, ... }:

let
  cfg = config.services.aispace.ollama;
in
with lib;
{
  options.services.aispace.ollama = {
    enable = mkEnableOption "Enable Ollama service";
    version = mkOption {
      type = types.str;
      default = "0.4.1";
      description = "Ollama version";
    };
    port = mkOption {
      type = types.port;
      default = 11434;
      description = "Port to expose Ollama on";
    };
    dataDir = mkOption {
      type = types.str;
      default = "${config.my.nas.serverConfigDir}/ollama";
      description = "Ollama data directory";
    };
    enableWeb = mkEnableOption "Enable Ollama web interface";
    webVersion = mkOption {
      type = types.str;
      default = "git-f5f2215-cuda";
      description = "Open-webui web version";
    };
    webPort = mkOption {
      type = types.port;
      default = 4040;
      description = "Port to expose Ollama Web UI on";
    };
    webDataDir = mkOption {
      type = types.str;
      default = "${config.my.nas.serverConfigDir}/open-webui";
      description = "open-webui data directory";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.ollama = {
      image = "ollama/ollama:${cfg.version}";
      ports = [ "${toString cfg.port}:11434" ];
      volumes = [ "${cfg.dataDir}:/root/.ollama" ];
      extraOptions = [
        "--device"
        "nvidia.com/gpu=all"
      ];
    };

    networking.firewall.allowedTCPPorts = [
      cfg.port
      # TODO: make this optional too, but I was fighting nix here with `lib.optional` inside this `lib.mkIf` block
      cfg.webPort
    ];

    virtualisation.oci-containers.containers.ollama-web = mkIf cfg.enableWeb {
      image = "ghcr.io/open-webui/open-webui:${cfg.webVersion}";
      ports = [ "${toString cfg.webPort}:8080" ];
      volumes = [ "${cfg.webDataDir}:/app/backend/data" ];
      environment = {
        ENABLE_SIGNUP = "false";
      };
      extraOptions = [
        "--device"
        "nvidia.com/gpu=all"
      ];
    };
  };
}
