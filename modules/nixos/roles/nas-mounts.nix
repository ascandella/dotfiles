{ config, lib, ... }:

{
  options = {
    my.nas = {
      serverConfigDir = lib.mkOption {
        type = lib.types.str;
        default = "/config";
      };
      downloadsDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/downloads";
      };
    };
  };

  config = {
    fileSystems = let
      nasBase = "truenas:/mnt/truepool-rust";
      nfsBase = {
        fsType = "nfs";
        options = [ "x-systemd.mount-timeout=3m" ];
      };
    in {
      "/media/movies" = nfsBase // { device = "${nasBase}/movies"; };
      "/media/tv" = nfsBase // { device = "${nasBase}/tv"; };
      "${config.my.nas.downloadsDir}" = nfsBase // {
        device = "${nasBase}/downloads";
      };
      "${config.my.nas.serverConfigDir}" = nfsBase // {
        device = "${nasBase}/server-config";
      };
    };
  };
}
