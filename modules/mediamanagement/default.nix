{ config, ... }:

let
  mediaGroup = config.my.media.group;
in
{
  imports = [
    ./overseerr.nix
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
        openFirewall = true;
      };
      sonarr = {
        enable = true;
        openFirewall = true;
      };
      tautulli = {
        enable = true;
      };
    };
  };
}
