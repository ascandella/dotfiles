{ config, ... }:

let
  dataDir = config.my.nas.serverConfigDir;
  mediaGroup = config.my.media.group;
in {
  imports = [ ./overseerr.nix ./homarr.nix ];

  config = {
    users = {
      users.${config.services.sonarr.user} = { extraGroups = [ mediaGroup ]; };
      users.${config.services.radarr.user} = { extraGroups = [ mediaGroup ]; };
    };

    services = {
      radarr = {
        enable = true;
        dataDir = "${dataDir}/radarr";
      };
      sonarr = {
        enable = true;
        dataDir = "${dataDir}/sonarr";
      };
      tautulli = {
        enable = true;
        dataDir = "${dataDir}/tautulli";
        configFile = "${dataDir}/tautulli/config.ini";
      };
      aispace.homarr = {
        enable = true;
        dataDir = "${dataDir}/homarr/data";
        iconsDir = "${dataDir}/homarr/icons";
        configDir = "${dataDir}/homarr/configs";
      };
    };

    systemd.services = {
      radarr = { after = [ "data-apps.mount" ]; };
      sonarr = { after = [ "data-apps.mount" ]; };
      tautulli = { after = [ "data-apps.mount" ]; };
      "${config.virtualisation.oci-containers.backend}-homarr" = {
        after = [ "data-apps.mount" ];
      };
    };
  };
}
