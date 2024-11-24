{ lib, config, ... }:

let
  cfg = config.services.aispace.home-assistant;
in
with lib;
{
  options.services.aispace.home-assistant = {
    enable = mkEnableOption (mdDoc "enable home-assistant via OCI container");
    version = mkOption {
      type = types.str;
      default = "2024.11.3";
    };
    port = mkOption {
      type = types.port;
      default = 8123;
    };
    user = mkOption {
      type = types.str;
      default = "hass";
    };
    uid = mkOption {
      type = types.int;
      default = 880;
    };
    gid = mkOption {
      type = types.int;
      default = 880;
    };
    dataDir = mkOption {
      type = types.path;
      default = "${config.my.nas.serverConfigDir}/home-assistant";
    };
    serialDevice = mkOption { type = types.str; };
    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open home-assistant.port to the outside network.
      '';
    };
  };

  config = mkIf cfg.enable {
    # TODO: https://github.com/NixOS/nixpkgs/issues/259770
    # Running podman as user doesn't work
    # users.users.${cfg.user} = {
    #   isSystemUser = true;
    #   createHome = true;
    #   home = "/var/lib/${cfg.user}";
    #   group = cfg.user;
    #   uid = cfg.uid;
    # };
    # users.groups.${cfg.user}.gid = cfg.gid;
    # temporary hack until official lingering support is added to `users.users`
    # systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/${cfg.user}" ];

    networking.firewall = mkIf cfg.openFirewall {
      # For Authentik access
      interfaces.wg0.allowedTCPPorts = [
        cfg.port
      ];
      # allowedTCPPorts = [ cfg.port ];
      # Homekit Bridge
      allowedTCPPortRanges = [
        {
          from = 21063;
          to = 21065;
        }
      ];
      allowedUDPPorts = [
        # Homekit Bridge
        5353
      ];
    };

    virtualisation.oci-containers.containers.home-assistant = {
      image = "ghcr.io/home-assistant/home-assistant:${cfg.version}";
      volumes = [
        "${cfg.dataDir}:/config"
        # `uv` needs to handlink so this can't be on NFS. It's fine if it gets
        # blown away; Home Assistant will re-install as needed
        "homeassistant-deps:/config/deps"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [
        "--network"
        "host"
        # For access to serial device
        "--group-add"
        "dialout"
        "--device"
        "${cfg.serialDevice}:${cfg.serialDevice}"

        # Special perms
        "--cap-add=NET_ADMIN"
        "--cap-add=NET_RAW"
      ];
      environment = {
        UV_LINK_MODE = "copy";
      };
    };
    systemd.services."${config.virtualisation.oci-containers.backend}-home-assistant" = {
      after = [ "data-apps.mount" ];
      # serviceConfig.User = cfg.user;
    };
  };
}
