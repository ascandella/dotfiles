{ config, ... }:

let dataDir = config.my.nas.serverConfigDir;
in {
  users = {
    users.${config.services.sonarr.user} = {
      extraGroups = [ config.my.media.group ];
    };
    users.${config.services.radarr.user} = {
      extraGroups = [ config.my.media.group ];
    };
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
