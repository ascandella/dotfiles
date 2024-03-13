{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
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

  outputs = { self, nixpkgs, home-manager, darwin, simple-bar-src }:
    let
      username = "aiden"; # $USER
      system = "aarch64-darwin"; # TODO make this work on linux

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

      homeDirPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "/${homeDirPrefix}/${username}";

    in rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#ai-studio
      darwinConfigurations = {
        ai-studio = import ./hosts/studio { inherit pkgs darwin home-manager username homeDirectory; };
        workbook = import ./hosts/workbook { inherit pkgs darwin home-manager username homeDirectory; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#ai-studio
      homeConfigurations = {
        ai-studio = darwinConfigurations.ai-studio.config.home-manager.users.${username}.home;
        workbook-studio = darwinConfigurations.workbook.config.home-manager.users.${username}.home;
      };
    };
}
