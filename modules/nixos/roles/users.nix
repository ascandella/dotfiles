{ pkgs, lib, config, pubkeys, username, ... }:

{
  options = {
    my.media = {
      group = lib.mkOption {
        type = lib.types.str;
        default = "media";
      };
    };
  };

  config = {
    users = {
      groups.aiden = {
        gid = 1000;
        name = "aiden";
      };

      groups.media = {
        gid = 2000;
        name = config.my.media.group;
      };

      users.${username} = {
        uid = 1000;
        isNormalUser = true;
        description = "Aiden";
        shell = pkgs.zsh;
        extraGroups = [ "networkmanager" "wheel" config.my.media.group ];
        openssh.authorizedKeys.keys = pubkeys.aispace.user;
      };
    };
  };
}
