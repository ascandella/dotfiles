{ lib, config, ... }:

let
  cfg = config.services.aispace.sponsorblocktv;
in
{
  options.services.aispace.sponsorblocktv = {
    enable = lib.mkEnableOption "Enable SponsorBlockTV integration";
    version = lib.mkOption {
      type = lib.types.str;
      default = "v2.0.6";
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.sponsorblocktv = {
      file = ../../../secrets/sponsorblocktv.age;
      path = "/etc/sponsorblocktv/config.json";
      symlink = false;
    };

    virtualisation.oci-containers.containers.sponsorblocktv = {
      image = "ghcr.io/dmunozv04/isponsorblocktv:${cfg.version}";
      volumes = [ "/etc/sponsorblocktv:/app/data" ];
      extraOptions = [ "--network=host" ];
    };
  };
}
