{ pkgs, darwin, home-manager, username, pubkeys, homeDirectory, inputs, ... }:

darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit pubkeys; };
  modules = [
    ../../modules/darwin
    ../../modules/common
    home-manager.darwinModules.home-manager
    {
      users.users.${username} = {
        home = homeDirectory;
        shell = pkgs.zsh;
      };
      home-manager.users.${username} = import ../../modules/home/home.nix {
        inherit username pkgs homeDirectory inputs;
      };
    }
  ];
}
