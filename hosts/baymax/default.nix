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
  hostname,
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
    ../../modules/home-options
    home-manager.nixosModules.home-manager
    {
      home-manager.users.${username} = import ../../modules/home/home.nix {
        inherit
          username
          homeDirectory
          hostname
          inputs
          pkgs
          pubkeys
          system
          ;
      };
    }
  ];
}
