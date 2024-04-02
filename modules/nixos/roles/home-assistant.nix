{ lib, config, ... }:

let
  haCfg = config.services.aispace.home-assistant;
  zwCfg = config.services.aispace.zwave-js;
in with lib; {
  options.services.aispace = {
    home-assistant = {
      enable = mkEnableOption (mdDoc "enable home-assistant via OCI container");
      user = lib.mkOption {
        type = lib.types.str;
        default = "hass";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        default = 880;
      };
      gid = lib.mkOption {
        type = lib.types.int;
        default = 880;
      };
    };
    zwave-js = {
      enable =
        mkEnableOption (mdDoc "enable zwave-js and UI via OCI container");
      user = lib.mkOption {
        type = lib.types.str;
        default = "zwavejs";
      };
      uid = lib.mkOption {
        type = lib.types.int;
        default = 881;
      };
      gid = lib.mkOption {
        type = lib.types.int;
        default = 881;
      };
    };
  };

  config = mkMerge [
    (mkIf haCfg.enable {
      users.users.${haCfg.user} = {
        isSystemUser = true;
        group = haCfg.user;
        uid = haCfg.uid;
      };
      users.groups.${haCfg.user}.gid = haCfg.gid;
      # TODO
    })
    (mkIf zwCfg.enable {
      users.users.${zwCfg.user} = {
        isSystemUser = true;
        group = zwCfg.user;
        uid = zwCfg.uid;
      };
      users.groups.${zwCfg.user}.gid = zwCfg.gid;
      # TODO
    })
  ];
}
