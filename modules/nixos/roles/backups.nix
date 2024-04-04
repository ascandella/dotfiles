{ config, ... }:

{
  age.secrets.baymax-borg.file = ../../../secrets/baymax-borg.age;

  services.borgbackup.jobs = let
    basicBorgJob = name: {
      encryption.mode = "none";
      encryption = {
        passCommand = "cat ${config.age.secrets.baymax-borg.path}";
      };
      extraCreateArgs = "--verbose --stats --checkpoint-interval 600";
      repo = "${config.my.nas.backupsDir}/borg/${name}";
      compression = "zstd,1";
      startAt = "daily";
      prune.keep = {
        within = "1d"; # Keep all archives from the last day
        daily = 7;
        weekly = 4;
        monthly = -1; # Keep at least one archive for each month
      };
    };
  in {
    media-management = basicBorgJob "media-management" // {
      paths = [
        config.services.radarr.dataDir
        config.services.sonarr.dataDir
        config.services.tautulli.dataDir
        config.services.aispace.homarr.dataDir
        config.services.aispace.homarr.configDir
      ];
    };
    gitea = basicBorgJob "gitea" // { paths = config.services.gitea.stateDir; };
  };
}
