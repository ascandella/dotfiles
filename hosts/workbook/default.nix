{ pkgs, darwin, home-manager, username, homeDirectory, ... }:

darwin.lib.darwinSystem {
  system = "aarch64-darwin";
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
        inherit username pkgs homeDirectory;
      };
    }
  ];
}
