{ config, lib, ... }:

let
  dataDir = config.my.nas.serverConfigDir;
  maintainerrCfg = config.my.maintainerr;
in
{
  options = {
    my.maintainerr = {
      version = lib.mkOption {
        type = lib.types.str;
        default = "3.11.2";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 6246;
      };
      user = {
        uid = lib.mkOption {
          type = lib.types.int;
          default = 993;
        };
        gid = lib.mkOption {
          type = lib.types.int;
          default = 991;
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "maintainerr";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "maintainerr";
        };
      };
    };
  };

  config = {
    users = {
      users.${maintainerrCfg.user.user} = {
        name = "maintainerr";
        inherit (maintainerrCfg.user) uid group;
        isSystemUser = true;
      };
      groups.${maintainerrCfg.user.group} = {
        inherit (maintainerrCfg.user) gid;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        maintainerrCfg.port
      ];
    };

    virtualisation.oci-containers.containers = {
      maintainerr = {
        podman = {
          user = maintainerrCfg.user.user;
        };
        image = "ghcr.io/maintainerr/maintainerr:${maintainerrCfg.version}";
        volumes = [
          # NOTE: Need to manually chown on first initialization
          # chown -R 993:991 ${dataDir}/maintainerr
          "${dataDir}/maintainerr:/opt/data"
        ];
        environment = {
          TZ = "America/Los_Angeles";
          UI_PORT = toString maintainerrCfg.port;
        };
      };
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-maintainerr" = {
      after = [ "data-apps.mount" ];
    };
  };
}
