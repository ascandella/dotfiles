{ pkgs, pubkeys, username, ...}:

{
  users = {
    groups.aiden = {
      gid = 1000;
      name = "aiden";
    };

    groups.media = {
      gid = 2000;
      name = "media";
    };

    users.${username} = {
      uid = 1000;
      isNormalUser = true;
      description = "Aiden";
      shell = pkgs.zsh;
      extraGroups = [ "networkmanager" "wheel" "media" ];
      openssh.authorizedKeys.keys = pubkeys.aispace.user;
    };
  };
}
