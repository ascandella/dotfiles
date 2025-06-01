{ pubkeys, pkgs, ... }:

{
  config = {
    security.sudo.wheelNeedsPassword = false;
    users = {
      users.installer = {
        uid = 1000;
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = pubkeys.aispace.user;
      };
    };

    environment.systemPackages = with pkgs; [
      git
      rsync
      zsh
      vim
      wget
      curl
    ];
    services.openssh.enable = true;

    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
