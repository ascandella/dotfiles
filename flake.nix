{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
      # TODO: Temporarily disabled because of rust-overlay build issues
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    television = {
      url = "github:alexpasmantier/television";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        naersk.follows = "naersk";
      };
    };

    # For television
    naersk = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/naersk";
    };

    # For generating installer ISO
    # https://github.com/nix-community/nixos-generators
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
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
      nixos-generators,
      comin,
      agenix,
      treefmt-nix,
      systems,
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
      username = hostname: if hostname == "workbook" then "ascandella" else "aiden";

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
      homeDirectory = host: "${homeDirPrefix host}/${username host}";

      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

    in
    {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#studio
      darwinConfigurations = builtins.listToAttrs (
        builtins.map (host: {
          name = host;
          value = import ./hosts/${host} {
            inherit
              darwin
              home-manager
              inputs
              pubkeys
              agenix
              ;
            username = username host;
            hostname = host;
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
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = pkgsForHost host;
            modules = [
              ./modules/home-options
              (import ./modules/home-options/host.nix {
                hostname = host;
              })
              (import ./modules/home/home.nix {
                system = systemForHost host;
                hostname = host;
                homeDirectory = homeDirectory host;
                username = username host;
                pkgs = pkgsForHost host;
                inherit
                  inputs
                  ;
              })
            ];
          };
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
              pubkeys
              agenix
              comin
              ;
            username = username host;
            hostname = host;
            system = systemForHost host;
            homeDirectory = homeDirectory host;
            pkgs = pkgsForHost host;
          };
        }) linuxHosts
      );

      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
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
          '';
          lint = packages.default;
          agenix = agenix.packages.${system}.default;
          installISO = nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit pubkeys;
            };
            format = "install-iso";
            modules = [
              {
                nix.registry.nixpkgs.flake = nixpkgs;
              }
              ./modules/installer
            ];
          };
        };
      }
    );
}
