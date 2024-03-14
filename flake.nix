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
      hostnames = builtins.attrNames (builtins.readDir ./hosts);
      systemForHost = hostname:
        if builtins.elem hostname ["studio" "workbook"] then "aarch64-darwin"
        else "x86_64-linux";
      #unstablePkgsForHost = hostname:
        #import unstable {
	  #system = systemForHost hostname;
	  #config.allowUnfree = true;
	#};
      username = "aiden"; # $USER
      system = "aarch64-darwin"; # TODO make this work on linux

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

      homeDirPrefix = if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
      homeDirectory = "${homeDirPrefix}/${username}";
      darwinOptions = {
       inherit pkgs darwin home-manager username homeDirectory inputs; 
      };
      nixosOptions = {
        inherit inputs pkgs nixpkgs home-manager username homeDirectory;
      };

    in rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#ai-studio
      darwinConfigurations = {
        ai-studio = import ./hosts/studio darwinOptions;
        workbook = import ./hosts/workbook darwinOptions;
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#ai-studio
      homeConfigurations = {
        ai-studio = darwinConfigurations.ai-studio.config.home-manager.users.${username}.home;
        workbook-studio = darwinConfigurations.workbook.config.home-manager.users.${username}.home;
      };

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#wallynix
      nixosConfigurations = {
        wallynix = import ./hosts/wallynix (nixosOptions // {
          system = systemForHost "wallynix";
        });
      };
    };
}
