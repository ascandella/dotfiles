{ lib, config, ... }:

let
  cfg = config.my.comin;
in
{
  options = with lib; {
    my.comin = {
      enable = mkEnableOption (mdDoc "enable comin auto-updater") // {
        default = true;
      };
      repoUrl = mkOption {
        type = types.str;
        default = "https://code.ndella.com/ai/ai-cloud.git";
      };
    };
  };

  config = {
    age.secrets = {
      gitea-cloud-token.file = ../../../secrets/gitea-cloud-token.age;
    };

    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = cfg.repoUrl;
          branches.main.name = "main";
          auth.access_token_path = config.age.secrets.gitea-cloud-token.path;
        }
      ];
    };
  };
}
