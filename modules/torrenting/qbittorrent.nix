{ config, lib, pkgs, ... }:
# From: https://github.com/pceiley/nix-config/blob/3854c687d951ee3fe48be46ff15e8e094dd8e89f/hosts/common/modules/qbittorrent.nix

with lib;

let
  cfg = config.services.qbittorrent;
  UID = 888;
  GID = 888;
in {
  options.services.qbittorrent = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/qbittorrent";
      description = lib.mdDoc ''
        The directory where qBittorrent stores its data files.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        User account under which qBittorrent runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent";
      description = lib.mdDoc ''
        Group under which qBittorrent runs.
      '';
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra groups for qbittorrent user
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc ''
        qBittorrent web UI port.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open services.qBittorrent.port to the outside network.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = literalExpression "pkgs.qbittorrent-nox";
      description = lib.mdDoc ''
        The qbittorrent package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    systemd.services.qbittorrent = {
      # based on the plex.nix service module and
      # https://github.com/qbittorrent/qBittorrent/blob/master/dist/unix/systemd/qbittorrent-nox%40.service.in
      description = "qBittorrent-nox service";
      documentation = [ "man:qbittorrent-nox(1)" ];
      after = [ "network.target" "media-downloads.mount" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
            #!${pkgs.bash}/bin/bash

            # Create data directory if it doesn't exist
            if ! test -d "$QBT_PROFILE"; then
              echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
              install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
            fi
          '';
        in "!${preStartScript}";

        ExecStart = "${cfg.package}/bin/qbittorrent-nox";
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        #Restart = "on-success";
        #UMask = "0002";
        #LimitNOFILE = cfg.openFilesLimit;
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.port;
      };
    };

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        uid = UID;
        inherit (cfg) extraGroups group;
      };
    };

    users.groups =
      mkIf (cfg.group == "qbittorrent") { qbittorrent = { gid = GID; }; };
  };
}
