{ config, ... }:

{
  age.secrets.gitea-db-pass = {
    file = ../../../secrets/gitea-db-pass.age;
    owner = config.services.gitea.user;
    mode = "0400";
  };

  services = {
    gitea = {
      enable = true;
      database = {
        type = "mysql";
        passwordFile = config.age.secrets.gitea-db-pass.path;
      };
      settings = {
        server = {
          HTTP_PORT = 3009;
          DOMAIN = "code.ndella.com";
          SSH_PORT = 9023;
        };
      };
    };

    mysqlBackup = { databases = [ "gitea" ]; };
  };
}
