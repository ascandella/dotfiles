{ lib, ... }:

with lib;
{
  options = {
    services.aispace.wireguard = {
      interface = mkOption {
        type = types.str;
        default = "wg0";
        description = "Wireguard interface to configure";
      };
    };
  };
}
