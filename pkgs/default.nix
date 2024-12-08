{ pkgs }:

{
  gitea-catppucin = pkgs.callPackage ./gitea-catppucin.nix { };
  vuetorrent = pkgs.callPackage ./vuetorrent.nix { };
}
