{
  description = "WoL's NixOS Configuration";

  inputs = {
    systems.url = "github:nix-systems/default-linux";

    # NixOS stable
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

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
      url = "github:WoLeo-Z/nix-secrets";
      flake = false;
    };

    # Others
    astal-shell.url = "github:knoopx/astal-shell";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      # url = "git+file:///home/wol/Projects/caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    tinted-theming-scheme = {
      url = "github:tinted-theming/schemes";
      flake = false;
    };

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

    nix-ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
      imports = [ inputs.treefmt-nix.flakeModule ];

      systems = import systems;

      perSystem =
        { pkgs, ... }:
        {
          # formatter = config.treefmt.wrapper;
          treefmt = {
            projectRoot = self;

            programs.nixfmt = {
              enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt.compiler;
              package = pkgs.nixfmt;
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
        overlays.default = import ./pkgs { inherit (nixpkgs) lib; };

        nixosConfigurations =
          let
            mkNixosConfiguration =
              hostName: system:
              let
                # Import our custom lib which merges helpers with nixpkgs.lib
                lib = import ./lib {
                  inherit inputs;
                  lib = nixpkgs.lib // home-manager.lib;
                };

                # Import modules
                modules = lib.collectModulePaths {
                  dir = ./modules;
                  includeDefault = true;
                };
              in
              nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = { inherit inputs lib; };
                modules = [
                  (./hosts + "/${hostName}/default.nix")

                  home-manager.nixosModules.home-manager

                  inputs.chaotic.nixosModules.default
                ]
                ++ modules;
              };
          in
          {
            obsidian = mkNixosConfiguration "obsidian" "x86_64-linux";
            vm = mkNixosConfiguration "vm" "x86_64-linux";
            vostro = mkNixosConfiguration "vostro" "x86_64-linux";
          };
      };
    };
}
