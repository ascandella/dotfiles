# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  config,
  lib,
  ...
}:

let
  wireguard = import ../../data/wireguard.nix { inherit lib; };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/roles/base.nix
    ../../modules/nixos/roles/comin.nix
    ../../modules/nixos/roles/logging.nix
    ../../modules/nixos/roles/ntfy.nix
    ../../modules/nixos/roles/podman.nix
    ../../modules/nixos/roles/users.nix
    ../../modules/nixos/roles/nvidia.nix
    ../../modules/nixos/roles/nas-mounts.nix
    ../../modules/nixos/roles/home-assistant.nix
    ../../modules/nixos/roles/zwave-js.nix
    ../../modules/nixos/roles/nextcloud.nix
    ../../modules/nixos/roles/k3s.nix
    ../../modules/nixos/roles/gitea.nix
    ../../modules/nixos/roles/backups.nix
    ../../modules/nixos/roles/sponsorblocktv.nix
    ../../modules/nixos/roles/ollama.nix
    ../../modules/nixos/roles/mosquitto.nix
    ../../modules/nixos/roles/frigate.nix
    ../../modules/nixos/roles/scrypted.nix
    ../../modules/nixos/roles/wireguard.nix
    ../../modules/common
    ../../modules/deploy
    ../../modules/plex
    ../../modules/torrenting
    ../../modules/mediamanagement
  ];

  age.secrets = {
    nutuser.file = ../../secrets/nutuser.age;
  };

  # Bootloader.
  boot = {
    loader = {
      timeout = 2;
      grub = {
        enable = true;
        device = "/dev/sda";
        useOSProber = true;
        configurationLimit = 5;
      };
    };

    kernel.sysctl = {
      "fs.inotify.max_user_instances" = 1024; # default 128
      # For Wireguard access to LAN
      "net.ipv4.ip_forward" = 1;
      # For Wireguard client
      "net.ipv4.conf.all.src_valid_mark" = 1;
      # For k3s / traefik with `externalTrafficPolicy: Local`
      "net.ipv6.conf.all.forwarding" = 1;
      # Ensure we propagate IPv6 settings from above into namespaces
      "net.core.devconf_inherit_init_net" = 1;
      # Better congestion control
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  networking = {
    hostName = "baymax";

    # Enable networking
    networkmanager.enable = true;

    firewall = {
      allowedTCPPortRanges = [
        # For dog alarm / soco-cli (Sonos)
        {
          from = 54000;
          to = 54100;
        }
      ];
      allowedUDPPorts = [
        # Wireguard
        51820
      ];
    };

    interfaces.ens19 = {
      ipv4.addresses = [
        {
          address = "10.4.0.35";
          prefixLength = 24;
        }
      ];
    };

    wireguard.interfaces.${config.my.services.aispace.wireguard.interface} =
      let
        # Hosts that are allowed to access lan over wireguard, not just this box
        localTunnelPeers = lib.concatStringsSep "," (
          lib.lists.flatten (
            map wireguard.ipsForClient [
              "aiphone"
              "workbook"
              "aipad"
            ]
          )
        );
        localNetworkInterface = "ens18";
      in
      {
        ips = [ "10.20.0.35/24" ];
        privateKeyFile = "/etc/wireguard/private-key";
        generatePrivateKeyFile = true;
        listenPort = 51820;

        peers = wireguard.peersForServer config.networking.hostName;

        postSetup = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i ${config.my.services.aispace.wireguard.interface} -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -A FORWARD -o ${config.my.services.aispace.wireguard.interface} -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${localTunnelPeers} -o ${localNetworkInterface} -j MASQUERADE
        '';

        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i ${config.my.services.aispace.wireguard.interface} -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -D FORWARD -o ${config.my.services.aispace.wireguard.interface}  -j ACCEPT;
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${localTunnelPeers} -o ${localNetworkInterface} -j MASQUERADE
        '';
      };
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nixos/roles/base.nix contains most of the base config

  power.ups = {
    enable = true;
    mode = "netserver";
    openFirewall = true;
    ups.usbups = {
      driver = "usbhid-ups";
      port = "auto";
      description = "USB UPS";
    };
    upsmon.monitor.usbups = {
      user = "nutuser";
    };
    upsd = {
      listen = [
        { address = "10.2.0.35"; }
        { address = "127.0.0.1"; }
      ];
    };
    users = {
      nutuser = {
        passwordFile = config.age.secrets.nutuser.path;
      };
    };
  };

  services = {
    # PROXMOOOOOX
    qemuGuest.enable = true;
    blueman.enable = true;
    # Custom services

    aispace = {
      home-assistant = {
        enable = true;
        openFirewall = true;
        serialDevice = "/dev/serial/by-id/usb-ITEAD_SONOFF_Zigbee_3.0_USB_Dongle_Plus_V2_20231215082359-if00";
      };

      zwave-js = {
        enable = true;
        openFirewall = true;
        serialDevice = "/dev/serial/by-id/usb-Zooz_800_Z-Wave_Stick_533D004242-if00";
      };

      frigate.enable = true;

      scrypted.enable = true;
      sponsorblocktv.enable = true;

      ollama.enable = true;
      ollama.enableWeb = true;
    };

    wireguard = {
      interface = "wg0";
    };

    openiscsi.name = "iqn.2024-11.com.nixos:baymax";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
