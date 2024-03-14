{ fileSystems, ...}:

{
  fileSystems = let
    nasBase = "truenas:/mnt/truepool-rust";
  in {
    "/media/movies" = {
      device = "${nasBase}/movies";
      fsType = "nfs";
    };
    "/media/tv" = {
      device = "${nasBase}/tv";
      fsType = "nfs";
    };
  };
}
