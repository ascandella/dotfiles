{ config, lib, ... }:

{
  options = {
    my.nas = {
      moviesDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/movies";
      };
      tvDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/tv";
      };
      serverConfigDir = lib.mkOption {
        type = lib.types.str;
        default = "/config";
      };
      downloadsDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/downloads";
      };
      nextcloudDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/nextcloud";
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
      "${config.my.nas.moviesDir}" = nfsBase // {
        device = "${nasBase}/movies";
      };
      "${config.my.nas.tvDir}" = nfsBase // { device = "${nasBase}/tv"; };
      "${config.my.nas.nextcloudDir}" = nfsBase // {
        device = "${nasBase}/nextcloud";
      };
      "${config.my.nas.downloadsDir}" = nfsBase // {
        device = "${nasBase}/downloads";
      };
      "${config.my.nas.serverConfigDir}" = nfsBase // {
        device = "${nasBase}/server-config";
      };
    };
  };
}
