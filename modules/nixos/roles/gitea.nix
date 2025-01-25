{
  config,
  lib,
  pkgs,
  ...
}:

let
  giteaEtcDir = "gitea";
in
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

  environment.etc."${giteaEtcDir}/public/assets/css".source = pkgs.gitea-catppucin;

  services = {
    gitea = {
      enable = true;
      database = {
        type = "mysql";
        passwordFile = config.age.secrets.gitea-db-pass.path;
      };
      mailerPasswordFile = config.age.secrets.gitea-fastmail-app-password.path;
      customDir = "/etc/${giteaEtcDir}";
      settings = {
        mailer = {
          ENABLED = true;
          PROTOCOL = "smtp+starttls";
          SMTP_ADDR = "smtp.fastmail.com";
          SMTP_PORT = 587;
          USER = "sc@ndella.com";
          FROM = "Gitea <gitea@sca.ndella.com>";
        };
        oauth2_client = {
          ENABLE_AUTO_REGISTRATION = true;
          ACCOUNT_LINKING = "login";
        };
        server = {
          HTTP_PORT = 3009;
          DOMAIN = "code.ndella.com";
          SSH_DOMAIN = "baymax.lfp";
          ROOT_URL = "https://code.ndella.com/";
        };
        service = {
          DISABLE_REGISTRATION = true;
          ENABLE_NOTIFY_MAIL = true;
        };
        session = {
          SESSION_LIFE_TIME = 604800; # 7 days
        };
        ui = {
          DEFAULT_THEME = "catppuccin-macchiato-sapphire";
          THEMES = lib.strings.concatStringsSep "," [
            "catppuccin-latte-rosewater"
            "catppuccin-latte-flamingo"
            "catppuccin-latte-pink"
            "catppuccin-latte-mauve"
            "catppuccin-latte-red"
            "catppuccin-latte-maroon"
            "catppuccin-latte-peach"
            "catppuccin-latte-yellow"
            "catppuccin-latte-green"
            "catppuccin-latte-teal"
            "catppuccin-latte-sky"
            "catppuccin-latte-sapphire"
            "catppuccin-latte-blue"
            "catppuccin-latte-lavender"
            "catppuccin-frappe-rosewater"
            "catppuccin-frappe-flamingo"
            "catppuccin-frappe-pink"
            "catppuccin-frappe-mauve"
            "catppuccin-frappe-red"
            "catppuccin-frappe-maroon"
            "catppuccin-frappe-peach"
            "catppuccin-frappe-yellow"
            "catppuccin-frappe-green"
            "catppuccin-frappe-teal"
            "catppuccin-frappe-sky"
            "catppuccin-frappe-sapphire"
            "catppuccin-frappe-blue"
            "catppuccin-frappe-lavender"
            "catppuccin-macchiato-rosewater"
            "catppuccin-macchiato-flamingo"
            "catppuccin-macchiato-pink"
            "catppuccin-macchiato-mauve"
            "catppuccin-macchiato-red"
            "catppuccin-macchiato-maroon"
            "catppuccin-macchiato-peach"
            "catppuccin-macchiato-yellow"
            "catppuccin-macchiato-green"
            "catppuccin-macchiato-teal"
            "catppuccin-macchiato-sky"
            "catppuccin-macchiato-sapphire"
            "catppuccin-macchiato-blue"
            "catppuccin-macchiato-lavender"
            "catppuccin-mocha-rosewater"
            "catppuccin-mocha-flamingo"
            "catppuccin-mocha-pink"
            "catppuccin-mocha-mauve"
            "catppuccin-mocha-red"
            "catppuccin-mocha-maroon"
            "catppuccin-mocha-peach"
            "catppuccin-mocha-yellow"
            "catppuccin-mocha-green"
            "catppuccin-mocha-teal"
            "catppuccin-mocha-sky"
            "catppuccin-mocha-sapphire"
            "catppuccin-mocha-blue"
            "catppuccin-mocha-lavender"
          ];
        };
      };
    };

    mysqlBackup = {
      databases = [ "gitea" ];
    };
  };
}
