{
  pkgs,
  darwin,
  home-manager,
  username,
  pubkeys,
  homeDirectory,
  inputs,
  hostname,
  ...
}:

darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = {
    inherit pubkeys username;
  };
  modules = [
    ../../modules/darwin
    ../../modules/common
    home-manager.darwinModules.home-manager
    {
      ids.gids.nixbld = 30000;
      users.users.${username} = {
        home = homeDirectory;
        shell = pkgs.zsh;
      };
      home-manager.users.${username} = import ../../modules/home/home.nix {
        system = "aarch64-darwin";
        inherit
          username
          pkgs
          homeDirectory
          inputs
          hostname
          ;
      };
    }
  ];
}
