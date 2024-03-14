{ inputs, pkgs, nixpkgs, home-manager, username, homeDirectory, system, ... }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    ./configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.users.${username} = import ../../modules/home/home.nix {
        inherit username homeDirectory inputs pkgs;
      };
    }
  ];
}
