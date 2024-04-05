{ config, ... }:

let
  dataDir = config.my.nas.serverConfigDir;
  mediaGroup = config.my.media.group;
in
{
  imports = [
    ./overseerr.nix
    ./homarr.nix
  ];

  config = {
    users = {
      users.${config.services.sonarr.user} = {
        extraGroups = [ mediaGroup ];
      };
      users.${config.services.radarr.user} = {
        extraGroups = [ mediaGroup ];
      };
    };

    services = {
      radarr = {
        enable = true;
      };
      sonarr = {
        enable = true;
      };
      tautulli = {
        enable = true;
      };
      aispace.homarr = {
        enable = true;
        dataDir = "${dataDir}/homarr/data";
        iconsDir = "${dataDir}/homarr/icons";
        configDir = "${dataDir}/homarr/configs";
      };
    };

    systemd.services = {
      "${config.virtualisation.oci-containers.backend}-homarr" = {
        after = [ "data-apps.mount" ];
      };
    };
  };
}
