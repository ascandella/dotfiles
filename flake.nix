{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-bar-src = {
      url = "github:Jean-Tinland/simple-bar";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      allHosts = builtins.attrNames (builtins.readDir ./hosts);
      darwinHosts = ["studio" "workbook"];
      isLinuxHost = host: !builtins.elem host darwinHosts;
      linuxHosts = builtins.filter isLinuxHost allHosts;

      systemForHost = hostname:
        if isLinuxHost hostname then "x86_64-linux"
        else "aarch64-darwin";
      username = "aiden";

      pkgsForHost = host: import nixpkgs {
        system = systemForHost host;

        config = {
          allowUnfree = true;
        };
      };
      pubkeys = import ./data/pubkeys.nix;

      homeDirPrefix = host:
        if systemForHost host == "aarch64-darwin" then "/Users"
        else "/home";
      homeDirectory = host: "${homeDirPrefix host}/${username}";

    in rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#studio
      darwinConfigurations = builtins.listToAttrs (builtins.map (host: {
        name = host;
        value = import ./hosts/${host} {
          inherit darwin home-manager username inputs;
          specialArgs = {
            inherit pubkeys;
          };
          homeDirectory = homeDirectory host;
          pkgs = pkgsForHost host;
        };
      }) darwinHosts);

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#studio
      homeConfigurations = builtins.listToAttrs (builtins.map (host: {
        name = host;
        value = darwinConfigurations.${host}.config.home-manager.users.${username}.home;
      }) darwinHosts);

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#wallynix
      nixosConfigurations = builtins.listToAttrs (builtins.map (host: {
        name = host;
        value = import ./hosts/${host} {
          inherit inputs nixpkgs home-manager username;
          specialArgs = {
            inherit pubkeys;
          };
          system = systemForHost host;
          homeDirectory = homeDirectory host;
          pkgs = pkgsForHost host;
        };
      }) linuxHosts);
    };
}
