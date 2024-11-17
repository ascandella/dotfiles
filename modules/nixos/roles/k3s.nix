{ config, pkgs, ... }:

{
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--node-label"
      "ai-location=home"
      "--disable=traefik"
    ];
  };

  # For Longhorn / Truenas iSCSI
  services.openiscsi = {
    enable = true;
    name = "iqn.2024-11.com.nixos:${config.networking.hostName}";
  };
  services.multipath = {
    enable = true;
    pathGroups = [ ];
    defaults = "
      user_friendly_names yes
      find_multipaths yes
    ";
  };

  environment.systemPackages = [ pkgs.k3s ];

  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
    # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
    # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  ];
}
