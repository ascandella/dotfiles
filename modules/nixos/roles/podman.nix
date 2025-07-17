{ lib, ... }:

{
  options = {
    my.podman = {
      networkCidr = lib.mkOption {
        type = lib.types.str;
        default = "10.88.0.0/16";
      };
    };
  };

  config = {
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias
        dockerCompat = true;

        autoPrune = {
          enable = true;
        };

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
      oci-containers = {
        backend = "podman";
      };
      containers = {
        enable = true;
        containersConf = {
          settings = {
            engine.cdi_spec_dirs = [
              "/etc/cdi"
              "/var/run/cdi"
            ];
          };
        };
      };
    };
  };
}
