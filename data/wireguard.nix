{ lib, ... }:

let
  clients = {
    aiphone = {
      publicKey = "E7Na0EHrtzzbctSmE20aXPB2Rjy+ZmNbBoN4WU4nhhw=";
      allowedIPs = [ "10.20.0.50/32" ];
    };
    workbook = {
      publicKey = "AibOOk67HA9JdNmQmmgw060cVGHb+STK072D8FJIDh8=";
      allowedIPs = [ "10.20.0.40/32" ];
    };
    studio = {
      publicKey = "STUdiOvSStsTJ2AOXsNAzydfHC1iSRvXRX8op08FP2g=";
      allowedIPs = [ "10.20.0.45/32" ];
    };
    aideck = {
      publicKey = "grTWxzNIQtYjXY6M3gYLWn8aUyBXHGZ53GyXAwpxLyU=";
      allowedIPs = [ "10.20.0.80/32" ];
    };
    aipad = {
      publicKey = "NW2smAK+DddZ43/EPt2+0G9+OjGbDDghwQUGwcjkuEc=";
      allowedIPs = [ "10.20.0.82/32" ];
    };
  };
  servers = {
    baymax = {
      publicKey = "tBAYmax7sr1szCXdyZVhLzrByLGeyYPCLtC5y5UXSyc=";
      allowedIPs = [ "10.20.0.35/32" ];
      endpoint = "sea.ndella.com:51820";
    };
    oracle = {
      publicKey = "A5KEeDIO3vHmovXe/hl/8vvAKtxcwditcBQrbh5WfGs=";
      allowedIPs = [ "10.20.0.100/32" ];
      endpoint = "sjc.ndella.com:51820";
    };
  };
in
{
  inherit clients servers;
  peersForServer =
    serverName:
    (
      lib.attrValues clients ++ lib.attrValues (lib.filterAttrs (name: value: name != serverName) servers)
    );
  ipsForClient = client: clients.${client}.allowedIPs;
}
