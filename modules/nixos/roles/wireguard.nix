{ lib, ... }:

with lib;
{
  options = mkOption {
    services.aispace.wireguard = mkOption {
      type = types.str;
      default = "wg0";
      description = "Wireguard interface to configure";
    };
  };
}
