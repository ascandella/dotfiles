{ lib, config, ... }:

let
  haCfg = config.services.aispace.home-assistant;
  zwCfg = config.services.aispace.zwave-js;
in with lib; {
  options.services.aispace = {
    home-assistant = {
      enable = mkEnableOption (mdDoc "enable home-assistant via OCI container");
      version = mkOption {
        type = types.str;
        default = "2024.3.3";
      };
      port = mkOption {
        type = types.int;
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
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open home-assistant.port to the outside network.
        '';
      };
    };

    zwave-js = {
      enable =
        mkEnableOption (mdDoc "enable zwave-js and UI via OCI container");
      version = mkOption {
        type = types.str;
        default = "9.9.1";
      };
      user = mkOption {
        type = types.str;
        default = "zwavejs";
      };
      port = mkOption {
        type = types.int;
        default = 8091;
      };
      serialDevice = mkOption { type = types.str; };
      uid = mkOption {
        type = types.int;
        default = 881;
      };
      gid = mkOption {
        type = types.int;
        default = 881;
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open zwave-js.port to the outside network.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf haCfg.enable {
      users.users.${haCfg.user} = {
        isSystemUser = true;
        group = haCfg.user;
        uid = haCfg.uid;
      };
      users.groups.${haCfg.user}.gid = haCfg.gid;

      networking.firewall =
        mkIf haCfg.openFirewall { allowedTCPPorts = [ haCfg.port ]; };

      virtualisation.oci-containers.containers.home-assistant = {
        # TODO
        image = "ghcr.io/home-assistant/home-assistant:${haCfg.version}";
      };
      systemd.services."${config.virtualisation.oci-containers.backend}-home-assistant" =
        {
          after = [ "data-apps.mount" ];
        };
    })
    (mkIf zwCfg.enable {
      users.users.${zwCfg.user} = {
        isSystemUser = true;
        group = zwCfg.user;
        uid = zwCfg.uid;
      };
      users.groups.${zwCfg.user}.gid = zwCfg.gid;
      # TODO

      networking.firewall =
        mkIf zwCfg.openFirewall { allowedTCPPorts = [ zwCfg.port ]; };

      virtualisation.oci-containers.containers.zwavejs = {
        image = "zwavejs/zwave-js-ui:${zwCfg.version}";
        ports = [ "${toString zwCfg.port}:8091" "3033:3000" ];
        extraOptions = [
          # For access to serial device
          "--group-add"
          "dialout"
          "--device"
          zwCfg.serialDevice
          "--userns="
        ];
      };
      systemd.services."${config.virtualisation.oci-containers.backend}-zwavejs" =
        {
          after = [ "data-apps.mount" ];
        };
    })
  ];
}
