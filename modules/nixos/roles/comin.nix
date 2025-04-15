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
    environment.etc."comin/gpg-key.asc" = {
      text = pubkeys.aispace.gpgPublicKey;
    };
    services.comin = {
      gpgPublicKeyPaths = [
        config.environment.etc."comin/gpg-key.asc".path
      ];
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
