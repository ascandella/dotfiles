{ nixpkgs, home-manager, system, ... }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager

  ];
}
