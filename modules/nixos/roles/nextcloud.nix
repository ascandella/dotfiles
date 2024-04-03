{ pkgs, ... }:

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
        https = true;
        config = {
          adminpassFile = "/etc/nextcloud/admin-pass";
          dbtype = "mysql";
          dbuser = "nextcloud";
          dbpassFile = "/etc/nextcloud/db-pass";
        };
      };
    };
  };
}