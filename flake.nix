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
    ghostty = {
      url = "github:ghostty-org/ghostty?tag=1.0.0";
      inputs = {
        nixpkgs-unstable.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zjstatus = {
      url = "github:dj95/zjstatus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      flake-utils,
      comin,
      deploy-rs,
      agenix,
      ...
    }@inputs:
    let
      allHosts = builtins.attrNames (builtins.readDir ./hosts);
      darwinHosts = [
        "studio"
        "workbook"
      ];
      isLinuxHost = host: !builtins.elem host darwinHosts;
      linuxHosts = builtins.filter isLinuxHost allHosts;

      systemForHost = hostname: if isLinuxHost hostname then "x86_64-linux" else "aarch64-darwin";
      username = "aiden";

      pkgsForHost =
        host:
        import nixpkgs {
          system = systemForHost host;

          config = {
            allowUnfree = true;
          };
        };
      pubkeys = import ./data/pubkeys.nix;

      homeDirPrefix = host: if systemForHost host == "aarch64-darwin" then "/Users" else "/home";
      homeDirectory = host: "${homeDirPrefix host}/${username}";

      deployPkgs =
        host:
        import nixpkgs {
          system = systemForHost host;
          overlays = [
            deploy-rs.overlay
            (self: super: {
              deploy-rs = {
                inherit (pkgsForHost host) deploy-rs;
                inherit (super.deploy-rs) lib;
              };
            })
          ];
        };
    in
    rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#studio
      darwinConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = import ./hosts/${host} {
            inherit
              darwin
              home-manager
              username
              inputs
              pubkeys
              agenix
              ;
            homeDirectory = homeDirectory host;
            pkgs = pkgsForHost host;
          };
        }) darwinHosts
      );

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#studio
      homeConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = darwinConfigurations.${host}.config.home-manager.users.${username}.home;
        }) darwinHosts
      );

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#baymax
      nixosConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = import ./hosts/${host} {
            inherit
              inputs
              nixpkgs
              home-manager
              username
              pubkeys
              agenix
              comin
              ;
            system = systemForHost host;
            homeDirectory = homeDirectory host;
            pkgs = pkgsForHost host;
          };
        }) linuxHosts
      );

      deploy = {
        user = "root";
        sshUser = "deploy";
        remoteBuild = true;

        nodes = builtins.listToAttrs (
          builtins.map (host: {
            name = host;
            value = {
              hostname = host;
              profiles.system = {
                path = (deployPkgs host).deploy-rs.lib.activate.nixos self.nixosConfigurations.${host};
              };
            };
          }) linuxHosts
        );
      };

      # doesn't work in GitHub actions
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        packages = with pkgs; {
          inherit statix nix nixfmt-rfc-style;
          nixfmt = nixfmt-rfc-style;
          fmt = pkgs.writeScriptBin "format" ''
            ${nixfmt-rfc-style}/bin/nixfmt .;
          '';
          # So you can run lint with:
          # nix run .
          default = pkgs.writeScriptBin "lint" ''
            #!${pkgs.bash}/bin/bash
            echo "Nix flake check"
            ${nix}/bin/nix flake check
            echo "Statix check"
            ${statix}/bin/statix check
            echo "Format check"
            ${nixfmt-rfc-style}/bin/nixfmt --check .
          '';
          lint = packages.default;
          agenix = agenix.packages.${system}.default;
        };
        apps = {
          inherit (deploy-rs.apps.${system}) deploy-rs;
        };
      }
    );
}
