{ pkgs, ... }:

{
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };
}
