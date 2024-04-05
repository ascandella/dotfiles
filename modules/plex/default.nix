{ pkgs, config, ... }:

{
  users.users.${config.services.plex.user} = {
    extraGroups = [ "media" ];
  };

  services.plex =
    let
      plexpass = pkgs.plex.override {
        plexRaw = pkgs.plexRaw.overrideAttrs (old: rec {
          version = "1.40.1.8227-c0dd5a73e";
          src = pkgs.fetchurl {
            url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
            sha256 = "sha256-odCJF7gdQ2E1JE8Q+HdzyvbMNJ67k3mgu9IKz7crXQ8=";
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
