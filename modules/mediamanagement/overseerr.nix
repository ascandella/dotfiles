{ config, lib, ... }:

let
  dataDir = config.my.nas.serverConfigDir;
  overseerrCfg = config.my.overseerr;
in
{
  options = {
    my.overseerr = {
      version = lib.mkOption {
        type = lib.types.str;
        default = "1.33.2";
      };
      user = {
        uid = lib.mkOption {
          type = lib.types.int;
          default = 994;
        };
        gid = lib.mkOption {
          type = lib.types.int;
          default = 992;
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "overseerr";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "overseerr";
        };
      };
    };
  };

  config = {
    users = {
      users.${overseerrCfg.user.user} = {
        name = "overseerr";
        inherit (overseerrCfg.user) uid group;
        isSystemUser = true;
      };
      groups.${overseerrCfg.user.group} = {
        inherit (overseerrCfg.user) gid;
      };
    };

    networking.firewall = {
      allowedTCPPorts = [
        # TODO: Expose via reverse proxy. Overseerr
        5055
      ];
    };

    virtualisation.oci-containers.containers = {
      overseerr = {
        image = "ghcr.io/linuxserver/overseerr:${overseerrCfg.version}";
        volumes = [
          # NOTE: Need to manually chown on first initialization
          "${dataDir}/overseerr:/config"
        ];
        # Can't run as user, but at least the files are owned by the proper user
        environment = {
          PUID = toString overseerrCfg.user.uid;
          PGID = toString overseerrCfg.user.gid;
        };
        extraOptions = [
          # Acess to Radarr / Sonarr
          "--network=host"
        ];
      };
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-overseerr" = {
      after = [ "data-apps.mount" ];
    };
  };
}
