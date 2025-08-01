{
  description = "WoL's NixOS Configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    # NixOS stable
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    # NixOS unstable
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small"; # moves faster, has less packages

    # nixpkgs-pinned.url = "github:NixOS/nixpkgs/awa";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake parts
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    # My secrets
    nix-secrets = {
      url = "git+ssh://git@github.com/WoLeo-Z/nix-secrets.git?shallow=1";
      flake = false;
    };

    # Others
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    nix-tree = {
      url = "github:utdemir/nix-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      systems,
      home-manager,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        ./pkgs
      ];

      systems = import systems;

      perSystem =
        { pkgs, ... }:
        {
          # formatter = config.treefmt.wrapper;
          treefmt = {
            projectRoot = self;

            programs.nixfmt = {
              enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt-rfc-style.compiler;
              package = pkgs.nixfmt-rfc-style;
              strict = true;
            };

            programs.shellcheck.enable = true;
            settings.formatter.shellcheck.options = [
              "-s"
              "bash"
            ];

            programs.deno.enable = true;

            programs.ruff.check = true;
            programs.ruff.format = true;
            settings.formatter.ruff-check.priority = 1;
            settings.formatter.ruff-format.priority = 2;
          };
        };

      flake = {
        nixosConfigurations =
          let
            # Import our custom lib which merges helpers with nixpkgs.lib
            lib = import ./lib {
              inherit inputs;
              lib = nixpkgs.lib // home-manager.lib;
            };

            # Import modules
            modules = lib.collectModules ./modules;

            # Import hosts
            hostConfigs =
              let
                hostDirs = builtins.attrNames (builtins.readDir ./hosts);

                getHostConfig =
                  hostName:
                  let
                    hostPath = ./hosts + "/${hostName}/default.nix";
                    config = import hostPath;
                  in
                  config {
                    inherit inputs lib;
                    # pkgs = nixpkgs.legacyPackages."x86_64-linux";
                  };
              in
              builtins.listToAttrs (
                builtins.map (hostName: {
                  name = hostName;
                  value = getHostConfig hostName;
                }) hostDirs
              );

            mkNixosConfiguration =
              hostName: hostConfig:
              nixpkgs.lib.nixosSystem {
                system = hostConfig.system;
                specialArgs = { inherit inputs lib; };
                modules = [
                  { networking.hostName = hostConfig.hostName; }

                  hostConfig.config
                  hostConfig.hardware

                  home-manager.nixosModules.home-manager

                  inputs.chaotic.nixosModules.default
                ]
                ++ modules;
              };
          in
          builtins.mapAttrs mkNixosConfiguration hostConfigs;
      };
    };
}
