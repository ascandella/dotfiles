{ pubkeys, username, pkgs, config, ... }:

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

      # Makes running sudo `nixos-rebuild switch` more convenient -- since
      # `deploy` user has the same SSH keys accepted, not a unique attack vector.
      users.${username} = { extraGroups = [ config.my.deploy.group ]; };
    };

    security.sudo.extraRules = [{
      groups = [ config.my.deploy.group ];
      commands = [
        # For local
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }

        # For remote
        {
          command = "/nix/store/*/activate-rs";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/rm";
          options = [ "NOPASSWD" ];
        }

        # Other
        {
          command = "/run/current-system/sw/bin/nix-collect-garbage";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };
}
