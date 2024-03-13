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
  };

  outputs = { self, nixpkgs, home-manager, darwin }:
    let
      username = "aiden"; # $USER
      system = "aarch64-darwin"; # TODO make this work on linux
      stateVersion = "23.11";     # See https://nixos.org/manual/nixpkgs/stable for most recent

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

      homeDirPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "/${homeDirPrefix}/${username}";

      home = ({ config, lib, ...}: {
        imports = [
          (import ./home.nix {
            inherit homeDirectory pkgs stateVersion system username config lib;
          })
        ];
      });
    in rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#ai-studio
      darwinConfigurations = {
        ai-studio = import ./hosts/studio { inherit pkgs darwin home-manager username homeDirectory; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#ai-studio
      homeConfigurations = {
        ai-studio = darwinConfigurations.ai-studio.config.home-manager.users.${username}.home;
      };
    };
}
