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
    jackett = {
      enable = true;
      openFirewall = true;
      dataDir = "${config.my.nas.serverConfigDir}/jackett";
    };
  };
}
