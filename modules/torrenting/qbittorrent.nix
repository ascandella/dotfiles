{
  config,
  lib,
  pkgs,
  ...
}:
# From: https://github.com/pceiley/nix-config/blob/3854c687d951ee3fe48be46ff15e8e094dd8e89f/hosts/common/modules/qbittorrent.nix

with lib;

let
  cfg = config.services.aispace.qbittorrent;
  UID = 888;
  GID = 888;
in
{
  options.services.aispace.qbittorrent = {
    enable = mkEnableOption (lib.mdDoc "qBittorrent headless");

    version = mkOption {
      type = types.str;
      default = "qbt5.0.3-20241218";
      description = "Docker hub image tage";
    };

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
    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    age.secrets.baymax-vpn = {
      inherit (cfg) group;
      file = ../../secrets/baymax-vpn.age;
      mode = "0400";
      owner = cfg.user;
    };

    systemd.services."${config.virtualisation.oci-containers.backend}-qbittorrent" = {
      after = [ "media-downloads.mount" ];
    };

    virtualisation.oci-containers.containers.qbittorrent = {
      image = "trigus42/qbittorrentvpn:${cfg.version}";
      environment = {
        # TODO: Not working with NFS mounts... permission denied
        # PGID = toString GID;
        # PUID = toString UID;

        # Use root for now...
        PGID = "0";
        PUID = "0";
        DOWNLOAD_DIR_CHOWN = "no";
        DEBUG = "yes";
        BIND_INTERFACE = "yes";
      };
      volumes = [
        "/var/lib/qbittorrent/qBittorrent:/config"
        "/run/agenix/baymax-vpn:/config/wireguard/wg1.conf:ro"
        "/etc/vuetorrent:/etc/vuetorrent:ro"
        "${config.my.nas.downloadsDir}:/downloads"
        "/dev/net/tun:/dev/net/tun"
      ];

      ports = [ "${config.my.network.privateAddress}:${toString cfg.port}:8080" ];

      extraOptions = [
        # Create wireguard interface
        "--cap-add=NET_ADMIN"
        # For pinging
        "--cap-add=NET_RAW"
      ];
    };

    users.users = mkIf (cfg.user == "qbittorrent") {
      qbittorrent = {
        uid = UID;
        inherit (cfg) extraGroups group;
      };
    };

    users.groups = mkIf (cfg.group == "qbittorrent") {
      qbittorrent = {
        gid = GID;
      };
    };
  };
}
