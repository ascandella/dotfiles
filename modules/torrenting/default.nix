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

  systemd.services.jackett = {
    after = [ "data-apps.mount" ];
  };
}
