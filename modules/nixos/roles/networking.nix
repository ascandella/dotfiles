{ lib, ... }:

{
  options = {
    my.network.privateAddress = lib.mkOption {
      type = lib.types.str;
    };
  };
}
