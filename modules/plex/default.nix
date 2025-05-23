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
          version = "1.41.6.9685-d301f511a";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-4ZbSGQGdkXCCZZ00w0/BwRHju4DJUQQBGid0gBFK0Ck=";
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
