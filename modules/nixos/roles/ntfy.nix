{ lib, ... }:

{
  options = {
    my.ntfy = {
      endpoint = lib.mkOption {
        type = lib.types.str;
        default = "https://ntfy.ndella.com";
      };
      homelabTopic = lib.mkOption {
        type = lib.types.str;
        default = "homelab";
      };
    };
  };
}
