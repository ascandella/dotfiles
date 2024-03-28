{ config, ... }:

{
  imports = [
    ./qbittorrent.nix
    ./vuetorrent.nix
  ];

  services = {
    qbittorrent = {
      enable = true;
      port = 9124;
      extraGroups = [ config.my.media.group ];
      openFirewall = true;
    };
    vuetorrent = {
      enable = true;
    };
  };
}
