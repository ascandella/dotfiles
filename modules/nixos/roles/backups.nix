{
  config,
  pkgs,
  lib,
  ...
}:

{
  age.secrets = {
    baymax-borg.file = ../../../secrets/baymax-borg.age;
    baymax-ntfy-token.file = ../../../secrets/baymax-ntfy-token.age;
  };

  systemd.services =
    {
      "notify-problems@" = {
        enable = true;
        environment.SERVICE = "%i";
        script = ''
          NTFY_TOKEN="$(cat ${config.age.secrets.baymax-ntfy-token.path})"
          ${pkgs.curl}/bin/curl \
            -H "Authorization: Bearer $NTFY_TOKEN" \
            -H "Title: $SERVICE failed" \
            -H "Tags: warning,skull" \
            -d "Run journalctl -u $SERVICE for details" \
            ${config.my.ntfy.endpoint}/${config.my.ntfy.homelabTopic}
        '';
      };
    }
    // lib.flip lib.mapAttrs' config.services.borgbackup.jobs (
      name: value:
      lib.nameValuePair "borgbackup-job-${name}" {
        unitConfig.OnFailure = "notify-problems@%i.service";
      }
    );

  services.borgbackup.jobs =
    let
      basicBorgJob = name: {
        encryption = {
          mode = "repokey-blake2";
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
    in
    {
      media-management = basicBorgJob "media-management" // {
        paths = [
          config.services.radarr.dataDir
          config.services.sonarr.dataDir
          config.services.tautulli.dataDir
          config.services.aispace.homarr.dataDir
          config.services.aispace.homarr.configDir
        ];
      };
      gitea = basicBorgJob "gitea" // {
        paths = config.services.gitea.stateDir;
      };
      mysql = basicBorgJob "mysql" // {
        paths = config.services.mysqlBackup.location;
      };
    };
}
