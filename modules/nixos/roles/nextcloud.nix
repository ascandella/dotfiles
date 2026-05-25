{ config, pkgs, ... }:

{
  config = {
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
    };
  };
}
