{ lib, ... }:

let
  clients = {
    aiphone = {
      publicKey = "E7Na0EHrtzzbctSmE20aXPB2Rjy+ZmNbBoN4WU4nhhw=";
      allowedIPs = [ "10.20.0.50/32" ];
    };
    workbook = {
      publicKey = "HCu0BSExp9ihj9s8sMjvr9bQ3Ol39OFCck7WFw5fLGU=";
      allowedIPs = [ "10.20.0.40/32" ];
    };
    studio = {
      publicKey = "j+GGVsCah/sbBUwDoEE3GeCiYbPk/knNWoxTw+SlEDM=";
      allowedIPs = [ "10.20.0.45/32" ];
    };
    aideck = {
      publicKey = "grTWxzNIQtYjXY6M3gYLWn8aUyBXHGZ53GyXAwpxLyU=";
      allowedIPs = [ "10.20.0.80/32" ];
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
}
