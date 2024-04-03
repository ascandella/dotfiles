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
        ensureUsers = [{
          name = "nextcloud";
          ensurePermissions = { "nextcloud.*" = "ALL PRIVILEGES"; };
        }];
      };

      nextcloud = {
        enable = true;
        hostName = "cloud.ndella.com";
        package = pkgs.nextcloud28;
        # TODO: enable
        # https = true;
        config = {
          adminpassFile = "/etc/nextcloud/admin-pass";
          dbtype = "mysql";
          dbuser = "nextcloud";
          dbpassFile = config.age.secrets.nextcloud-db-pass.path;
          dbtableprefix = "";
        };
        settings = {
          loglevel = 1; # TODO: tune down to 2
          trusted_domains = [ "baymax.lfp" ];
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

    # TODO: Remove after k8s installed
    networking.firewall = { allowedTCPPorts = [ 8082 ]; };
  };
}
