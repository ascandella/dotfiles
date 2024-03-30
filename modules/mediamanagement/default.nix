{ config, ... }:

let
  dataDir = config.my.nas.serverConfigDir;
  mediaGroup = config.my.media.group;
in {
  users = {
    users.${config.services.sonarr.user} = { extraGroups = [ mediaGroup ]; };
    users.${config.services.radarr.user} = { extraGroups = [ mediaGroup ]; };
  };

  services = {
    radarr = {
      enable = true;
      dataDir = "${dataDir}/radarr";
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      dataDir = "${dataDir}/sonarr";
      openFirewall = true;
    };
  };
}
