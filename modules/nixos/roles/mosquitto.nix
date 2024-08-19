{ config, ... }:

{

  age.secrets = {
    mosquitto-homeassistant.file = ../../../secrets/mosquitto-homeassistant.age;
    mosquitto-frigate.file = ../../../secrets/mosquitto-frigate.age;
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.homeassistant = {
          acl = [ "readwrite #" ];
          hashedPasswordFile = config.age.secrets.mosquitto-homeassistant.path;
        };
        users.frigate = {
          acl = [ "readwrite #" ];
          hashedPasswordFile = config.age.secrets.mosquitto-frigate.path;
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];
}
