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
  };
  servers = {
    baymax = {
      publicKey = "tBAYmax7sr1szCXdyZVhLzrByLGeyYPCLtC5y5UXSyc=";
      allowedIPs = [ "10.20.0.35/32" ];
    };
  };
in {
  inherit clients servers;
  peersForServer = serverName:
    clients ++ (lib.filterAttrs (name: value: name != serverName) servers);
}
