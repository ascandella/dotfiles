{ pkgs, pubkeys, ...}:

{
  users.groups.aiden = {
    gid = 1000;
    name = "aiden";
  };

  users.groups.media = {
    gid = 2000;
    name = "media";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aiden = {
    uid = 1000;
    isNormalUser = true;
    description = "Aiden";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "media" ];
    openssh.authorizedKeys.keys = pubkeys.aispace.users;
  };
}
