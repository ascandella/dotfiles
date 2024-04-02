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
        default = "/data/apps";
      };
      downloadsDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/downloads";
      };
      nextcloudDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/nextcloud";
      };
      squashGroup = lib.mkOption {
        type = lib.types.str;
        default = "nfs-mounts";
      };
      squashGroupId = lib.mkOption {
        type = lib.types.int;
        default = 1002;
      };
    };
  };

  config = {
    users = {
      users.root = {
        # For OCI containers running as root
        extraGroups = [ config.my.nas.squashGroup ];
      };
      groups.${config.my.nas.squashGroup} = {
        gid = config.my.nas.squashGroupId;
      };
    };

    fileSystems = let
      nasMappings = {
        movies = config.my.nas.moviesDir;
        tv = config.my.nas.tvDir;
        nextcloud = config.my.nas.nextcloudDir;
        downloads = config.my.nas.downloadsDir;
        server-config = config.my.nas.serverConfigDir;
      };
    in lib.concatMapAttrs (source: destination: {
      "${destination}" = {
        fsType = "nfs";
        options = [ "x-systemd.mount-timeout=3m" ];
        device = "truenas:/mnt/truepool-rust/${source}";
      };
    }) nasMappings;
  };
}
