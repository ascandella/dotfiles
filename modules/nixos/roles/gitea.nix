{ config, ... }:

{
  age.secrets = {
    gitea-db-pass = {
      file = ../../../secrets/gitea-db-pass.age;
      owner = config.services.gitea.user;
      mode = "0400";
    };
    gitea-fastmail-app-password = {
      file = ../../../secrets/gitea-fastmail-app-password.age;
      owner = config.services.gitea.user;
      mode = "0400";
    };
  };

  services = {
    gitea = {
      enable = true;
      database = {
        type = "mysql";
        passwordFile = config.age.secrets.gitea-db-pass.path;
      };
      mailerPasswordFile = config.age.secrets.gitea-fastmail-app-password.path;
      settings = {
        server = {
          HTTP_PORT = 3009;
          DOMAIN = "code.ndella.com";
          SSH_DOMAIN = "baymax.lfp";
          ROOT_URL = "https://code.ndella.com/";
        };
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtp";
          SMTP_ADDR = "smtp.fastmail.com:587";
          USER = "sc@ndella.com";
          FROM = "Gitea <gitea@sca.ndella.com>";
        };
        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_NOTIFY_MAIL = true;
        };
        openid = {
          ENABLE_OPENID_SIGNIN = true;
          ENABLE_OPENID_SIGNUP = true;
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "login";
        };
      };
    };

    mysqlBackup = {
      databases = [ "gitea" ];
    };
  };
}
