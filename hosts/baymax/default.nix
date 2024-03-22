{ inputs, pkgs, nixpkgs, home-manager, username, pubkeys, homeDirectory, system, ... }:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit pubkeys username;
  };
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
