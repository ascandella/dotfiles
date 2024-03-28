{ fileSystems, ... }:

{
  fileSystems =
    let
      nasBase = "truenas:/mnt/truepool-rust";
      nfsBase = {
        fsType = "nfs";
        options = [ "x-systemd.mount-timeout=3m" ];
      };
    in
    {
      "/media/movies" = nfsBase // {
        device = "${nasBase}/movies";
      };
      "/media/tv" = nfsBase // {
        device = "${nasBase}/tv";
      };
      "/media/downloads" = nfsBase // {
        device = "${nasBase}/downloads";
      };
      "/config" = nfsBase // {
        device = "${nasBase}/server-config";
      };
    };
}
