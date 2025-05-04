{ config, ... }:

{

  age.secrets = {
    mosquitto-homeassistant.file = ../../../secrets/mosquitto-homeassistant.age;
    mosquitto-frigate.file = ../../../secrets/mosquitto-frigate.age;
    mosquitto-opensprinkler.file = ../../../secrets/mosquitto-opensprinkler.age;
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users = {
          homeassistant = {
            acl = [ "readwrite #" ];
            hashedPasswordFile = config.age.secrets.mosquitto-homeassistant.path;
          };
          frigate = {
            acl = [ "readwrite #" ];
            hashedPasswordFile = config.age.secrets.mosquitto-frigate.path;
          };
          opensprinkler = {
            acl = [ "readwrite opensprinkler/#" ];
            hashedPasswordFile = config.age.secrets.mosquitto-opensprinkler.path;
          };
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [ 1883 ];
}
