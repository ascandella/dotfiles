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
    flake-utils.url = "github:numtide/flake-utils";

    # For accessing `deploy-rs`'s utility Nix functions
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, flake-utils, deploy-rs, ... }@inputs:
    let
      allHosts = builtins.attrNames (builtins.readDir ./hosts);
      darwinHosts = [ "studio" "workbook" ];
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

      deployPkgs = host: import nixpkgs {
        system = systemForHost host;
        overlays = [
          deploy-rs.overlay
          (self: super: {
            deploy-rs = {
              inherit (pkgsForHost host) deploy-rs;
              lib = super.deploy-rs.lib;
            };
          })
        ];
      };

    in
    rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#studio
      darwinConfigurations = builtins.listToAttrs (builtins.map
        (host: {
          name = host;
          value = import ./hosts/${host} {
            inherit darwin home-manager username inputs pubkeys;
            homeDirectory = homeDirectory host;
            pkgs = pkgsForHost host;
          };
        })
        darwinHosts);

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#studio
      homeConfigurations = builtins.listToAttrs (builtins.map
        (host: {
          name = host;
          value = darwinConfigurations.${host}.config.home-manager.users.${username}.home;
        })
        darwinHosts);

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#baymax
      nixosConfigurations = builtins.listToAttrs (builtins.map
        (host: {
          name = host;
          value = import ./hosts/${host} {
            inherit inputs nixpkgs home-manager username pubkeys;
            system = systemForHost host;
            homeDirectory = homeDirectory host;
            pkgs = pkgsForHost host;
          };
        })
        linuxHosts);

      deploy = {
        user = "root";
        sshUser = "deploy";
        remoteBuild = true;

        nodes = builtins.listToAttrs (builtins.map
          (host: {
            name = host;
            value = {
              hostname = host;
              profiles.system = {
                path = (deployPkgs host).deploy-rs.lib.activate.nixos self.nixosConfigurations.baymax;
              };
            };
          })
          linuxHosts);
      };

      # doesn't work in GitHub actions
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    } // flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = with pkgs; {
          inherit statix nix nixpkgs-fmt;
          fmt = pkgs.writeScriptBin "format" ''
            ${nixpkgs-fmt}/bin/nixpkgs-fmt .;
          '';
          # So you can run lint with:
          # nix run .
          default = pkgs.writeScriptBin "lint" ''
            echo "Nix flake check"
            ${nix}/bin/nix flake check
            echo "Statix check"
            ${statix}/bin/statix check
            echo "Format check"
            ${nixpkgs-fmt}/bin/nixpkgs-fmt --check .
          '';
          lint = packages.default;
        };
        apps = {
          deploy-rs = deploy-rs.apps.${system}.deploy-rs;
        };
      });
}
