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
      serialDevice = mkOption { type = types.str; };
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
      # TODO: https://github.com/NixOS/nixpkgs/issues/259770
      # Running podman as user doesn't work
      # users.users.${haCfg.user} = {
      #   isSystemUser = true;
      #   createHome = true;
      #   home = "/var/lib/${haCfg.user}";
      #   group = haCfg.user;
      #   uid = haCfg.uid;
      # };
      # users.groups.${haCfg.user}.gid = haCfg.gid;
      # temporary hack until official lingering support is added to `users.users`
      # systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/${haCfg.user}" ];

      networking.firewall =
        mkIf haCfg.openFirewall { allowedTCPPorts = [ haCfg.port ]; };

      virtualisation.oci-containers.containers.home-assistant = {
        # TODO: This
        image = "ghcr.io/home-assistant/home-assistant:${haCfg.version}";
      };
      systemd.services."${config.virtualisation.oci-containers.backend}-home-assistant" =
        {
          after = [ "data-apps.mount" ];
          # serviceConfig.User = haCfg.user;
        };
    })

    (mkIf zwCfg.enable {
      # TODO: https://github.com/NixOS/nixpkgs/issues/259770
      # users.users.${zwCfg.user} = {
      #   isSystemUser = true;
      #   createHome = true;
      #   home = "/var/lib/${zwCfg.user}";
      #   group = zwCfg.user;
      #   uid = zwCfg.uid;
      #   subUidRanges = [{
      #     startUid = 200000 + zwCfg.uid;
      #     count = 65536;
      #   }];
      #   subGidRanges = [{
      #     startGid = 200000 + zwCfg.gid;
      #     count = 65536;
      #   }];
      # };
      # users.groups.${zwCfg.user}.gid = zwCfg.gid;
      # temporary hack until official lingering support is added to `users.users`
      # systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/${zwCfg.user}" ];

      networking.firewall =
        mkIf zwCfg.openFirewall { allowedTCPPorts = [ zwCfg.port ]; };

      virtualisation.oci-containers.containers.zwavejs = {
        image = "zwavejs/zwave-js-ui:${zwCfg.version}";
        ports = [ "${toString zwCfg.port}:8091" "3033:3000" ];
        volumes =
          [ "${config.my.nas.serverConfigDir}/zwavejs:/usr/src/app/store" ];
        extraOptions = [
          # For access to serial device
          "--group-add"
          "dialout"
          "--device"
          zwCfg.serialDevice
          # "--userns="
        ];
      };
      systemd.services."${config.virtualisation.oci-containers.backend}-zwavejs" =
        {
          after = [ "data-apps.mount" ];
          # serviceConfig.User = zwCfg.user;
        };
    })
  ];
}
