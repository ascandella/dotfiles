{ pkgs, config, ... }:

{
  users.users.${config.services.plex.user} = {
    extraGroups = [
      "media" # for NAS shares
      "video" # for tuner card
    ];
  };

  services.plex =
    let
      plexpass = pkgs.plex.override {
        plexRaw = pkgs.plexRaw.overrideAttrs (_old: rec {
          version = "1.43.0.10492-121068a07";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-HA779rkjy8QBlW2+IsRmgu4t5PT2Gy0oaqcJm+9zCYE=";
          };
        });
      };
    in
    {
      enable = true;
      openFirewall = true;
      package = plexpass;
    };

  systemd.services.plex = {
    after = [
      "data-apps.mount"
      "media-tv.mount"
      "media-movies.mount"
    ];
  };
}
