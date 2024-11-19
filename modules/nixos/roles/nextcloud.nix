{ config, pkgs, ... }:

{
  config = {
    age.secrets.nextcloud-db-pass = {
      owner = "nextcloud";
      group = "nextcloud";
      file = ../../../secrets/nextcloud-db-pass.age;
      mode = "0400";
      path = "/etc/nextcloud/db-pass";
    };

    services = {
      mysqlBackup = {
        enable = true;
        databases = [ "nextcloud" ];
      };
      mysql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        package = pkgs.mysql80;
        ensureUsers = [
          {
            name = "nextcloud";
            ensurePermissions = {
              "nextcloud.*" = "ALL PRIVILEGES";
            };
          }
        ];
        settings = {
          mysqld = {
            # Bug in nextcloud 30
            # https://github.com/nextcloud/server/issues/47275#issuecomment-2360521770
            sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION";
          };
        };
      };

      nextcloud = {
        enable = true;
        hostName = "cloud.ndella.com";
        package = pkgs.nextcloud30;
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps)
            # Set to default with:
            #   nextcloud-occ config:app:set --value=0 user_oidc allow_multiple_user_backends
            user_oidc
            previewgenerator
            ;
        };
        https = true;
        maxUploadSize = "5G";
        config = {
          adminpassFile = "/etc/nextcloud/admin-pass";
          dbtype = "mysql";
          dbuser = "nextcloud";
          dbpassFile = config.age.secrets.nextcloud-db-pass.path;
        };
        settings = {
          loglevel = 2;
          trusted_proxies = [
            "10.42.0.0/24"
            "10.43.0.0/16"
          ];
        };
      };

      nginx.virtualHosts.${config.services.nextcloud.hostName}.listen = [
        {
          addr = "0.0.0.0";
          port = 8082;
        }
        {
          addr = "[::0]";
          port = 8082;
        }
      ];
    };
    systemd.timers.nextcloud-previewgenerator-cron = {
      wantedBy = [ "timers.target" ];
      after = [ "nextcloud-setup.service" ];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "10m";
        Unit = "nextcloud-previewgenerator-cron.service";
      };
    };
    systemd.services = {
      nextcloud-setup = {
        after = [ "mysql.service" ];
      };
      nextcloud-previewgenerator-cron = {
        after = [ "nextcloud-setup.service" ];
        environment.NEXTCLOUD_CONFIG_DIR = config.services.nextcloud.datadir;
        serviceConfig = {
          Type = "oneshot";
          User = "nextcloud";
          ExecStart = "${config.services.nextcloud.occ}/bin/nextcloud-occ preview:pre-generate";
        };
      };
    };

  };
}
