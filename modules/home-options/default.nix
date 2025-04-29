{ pkgs, ... }:

{
  options = {
    my = {
      configDir = pkgs.lib.mkOption {
        type = pkgs.lib.types.str;
        default = "/etc/nixos";
        description = "Location of the nix config directory (this repo)";
      };
      gitEmail = pkgs.lib.mkOption {
        type = pkgs.lib.types.str;
        default = "git@sca.ndella.com";
        description = "Git email address";
      };
      caCert = {
        enable = pkgs.lib.mkEnableOption "Enable custom CA cert";
        path = pkgs.lib.mkOption {
          type = pkgs.lib.types.str;
          default = null;
          description = "Custom CA cert path";
        };
      };
    };
  };
}
