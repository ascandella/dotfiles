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
      backupsDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/backups";
      };
      serverConfigDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/apps";
      };
      frigateDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/frigate";
      };
      downloadsDir = lib.mkOption {
        type = lib.types.str;
        default = "/media/downloads";
      };
      nextcloudDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/nextcloud/data";
      };
      pvcsDir = lib.mkOption {
        type = lib.types.path;
        default = "/data/nas-pvcs";
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
    age.secrets = {
      truenas-nixos.file = ../../../secrets/truenas-nixos.age;
    };

    users = {
      users.root = {
        # For OCI containers running as root
        extraGroups = [ config.my.nas.squashGroup ];
      };
      groups.${config.my.nas.squashGroup} = {
        gid = config.my.nas.squashGroupId;
      };
    };

    fileSystems =
      let
        nfsMappings = {
          movies = config.my.nas.moviesDir;
          tv = config.my.nas.tvDir;
          nextcloud = config.my.nas.nextcloudDir;
          downloads = config.my.nas.downloadsDir;
          server-config = config.my.nas.serverConfigDir;
          frigate = config.my.nas.frigateDir;
          pvcs = config.my.nas.pvcsDir;
        };
        smbMappings = {
          backups = config.my.nas.backupsDir;
        };
        # truenas-internal; DNS failures on boot sometimes
        truenasHost = "10.4.0.40";
      in
      lib.concatMapAttrs (source: destination: {
        "${destination}" = {
          fsType = "nfs";
          options = [ "x-systemd.mount-timeout=3m" ];
          device = "${truenasHost}:/mnt/truepool-rust/${source}";
        };
      }) nfsMappings
      // lib.concatMapAttrs (source: destination: {
        "${destination}" = {
          fsType = "cifs";
          options = [ "x-systemd.mount-timeout=1m,credentials=${config.age.secrets.truenas-nixos.path}" ];
          # truenas-internal; DNS failures on boot sometimes
          device = "//${truenasHost}/${source}";
        };
      }) smbMappings;
  };
}
