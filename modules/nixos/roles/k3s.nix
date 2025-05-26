{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.aispace.k3s;
  oidc = lib.types.submodule (
    { _ }:
    {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether OIDC auth is enabled for k3s";
      };
      issuerUrl = lib.mkOption {
        type = lib.types.nonEmptyStr;
        example = "https://oidc.example.com/application/o/kubernetes";
        description = "The OIDC issuer URL";
      };
      clientId = lib.mkOption {
        type = lib.types.nonEmptyStr;
        example = "kubernetes";
        description = "The OIDC client ID";
      };
      emailClaim = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "email";
        example = "email";
        description = "The OIDC claim to use for the email address";
      };
      groupsClaim = lib.mkOption {
        type = lib.types.nonEmptyStr;
        default = "groups";
        example = "groups";
        description = "The OIDC claim to use for user groups";
      };
    }
  );
in
{
  options = {
    services.aispace.k3s = {
      enable = lib.mkEnableOption "enable k3s server";
      oidc = lib.mkOption {
        type = lib.types.attrsOf oidc;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      k3s = {
        enable = true;
        role = "server";
        extraFlags = toString [
          "--node-label"
          "ai-location=home"
          "--disable=traefik"
        ];
      };

      # For Longhorn / Truenas iSCSI
      openiscsi = {
        enable = true;
        name = "iqn.2024-11.com.nixos:${config.networking.hostName}";
      };
      multipath = {
        enable = true;
        pathGroups = [ ];
        defaults = "
      user_friendly_names yes
      find_multipaths yes
    ";
      };
    };

    environment.systemPackages = [ pkgs.k3s ];

    networking.firewall.allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      # 2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      # 2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    ];
  };
}
