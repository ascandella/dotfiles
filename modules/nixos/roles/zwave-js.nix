{ lib, config, ... }:

let
  cfg = config.services.aispace.zwave-js;
in
with lib;
{
  options.services.aispace.zwave-js = {
    enable = mkEnableOption (mdDoc "enable zwave-js and UI via OCI container");
    version = mkOption {
      type = types.str;
      default = "9.18";
    };
    user = mkOption {
      type = types.str;
      default = "zwavejs";
    };
    port = mkOption {
      type = types.port;
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

  config = mkIf cfg.enable {
    # TODO: https://github.com/NixOS/nixpkgs/issues/259770
    # users.users.${cfg.user} = {
    #   isSystemUser = true;
    #   createHome = true;
    #   home = "/var/lib/${cfg.user}";
    #   group = cfg.user;
    #   uid = cfg.uid;
    #   subUidRanges = [{
    #     startUid = 200000 + cfg.uid;
    #     count = 65536;
    #   }];
    #   subGidRanges = [{
    #     startGid = 200000 + cfg.gid;
    #     count = 65536;
    #   }];
    # };
    # users.groups.${cfg.user}.gid = cfg.gid;
    # temporary hack until official lingering support is added to `users.users`
    # systemd.tmpfiles.rules = [ "f /var/lib/systemd/linger/${cfg.user}" ];

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    virtualisation.oci-containers.containers.zwavejs = {
      image = "zwavejs/zwave-js-ui:${cfg.version}";
      ports = [
        "${toString cfg.port}:8091"
        "3033:3000"
      ];
      volumes = [ "${config.my.nas.serverConfigDir}/zwavejs:/usr/src/app/store" ];
      extraOptions = [
        # For access to serial device
        "--group-add"
        "dialout"
        "--device"
        "${cfg.serialDevice}:${cfg.serialDevice}"
      ];
    };
    systemd.services."${config.virtualisation.oci-containers.backend}-zwavejs" = {
      after = [ "data-apps.mount" ];
      # serviceConfig.User = cfg.user;
    };
  };
}
