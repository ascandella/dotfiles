{
  lib,
  config,
  pubkeys,
  ...
}:

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
        default = "https://github.com/ascandella/dotfiles.git";
      };
    };
  };

  config = {
    services.comin = {
      enable = true;
      remotes = [
        {
          name = "origin";
          url = cfg.repoUrl;
          branches.main.name = "main";
          branches.testing.name = "testing";
        }
      ];
    };
  };
}
