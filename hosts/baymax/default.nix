{
  inputs,
  pkgs,
  nixpkgs,
  comin,
  home-manager,
  username,
  pubkeys,
  homeDirectory,
  system,
  agenix,
  ...
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    inherit pubkeys username;
  };
  modules = [
    ./configuration.nix
    agenix.nixosModules.default
    comin.nixosModules.comin
    home-manager.nixosModules.home-manager
    {
      home-manager.users.${username} = import ../../modules/home/home.nix {
        inherit
          username
          homeDirectory
          inputs
          pkgs
          system
          ;
      };
    }
  ];
}
