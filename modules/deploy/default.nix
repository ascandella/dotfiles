{ username, pubkeys, pkgs, config, ... }:

{
  options.my = {
    deploy.user = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "deploy";
      description = "Deploy user name";
    };
    deploy.group = pkgs.lib.mkOption {
      type = pkgs.lib.types.str;
      default = "deploy";
      description = "Deploy group name";
    };
  };

  config = {
    users = {
      groups.${config.my.deploy.group} = { };
      users.${config.my.deploy.user} = {
        extraGroups = [ config.my.deploy.group ];
        isSystemUser = true;
        group = "deploy";
        shell = pkgs.bash;
        openssh.authorizedKeys.keys = pubkeys.aispace.user;
      };

      users.${username} = {
        extraGroups = [ config.my.deploy.group ];
      };
    };

    security.sudo.extraRules = [
      {
        groups = [ config.my.deploy.group ];
        commands = [
          # For local
          {
            command = "/run/current-system/sw/bin/nixos-rebuild";
            options = [ "NOPASSWD" ];
          }

          # For remote
          {
            command = "/nix/store/*/bin/switch-to-configuration";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-store";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-env";
            options = [ "NOPASSWD" ];
          }
          {
            command = ''/bin/sh -c "readlink -e /nix/var/nix/profiles/system || readlink -e /run/current-system"'';
            options = [ "NOPASSWD" ];
          }
          {
            command = "/run/current-system/sw/bin/nix-collect-garbage";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
