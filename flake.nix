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

    # Hyprland & Hyprland Contrib repos

    # to be able to use the binary cache, we should avoid
    # overriding the nixpkgs input - as the resulting hash would
    # mismatch if packages are built against different versions
    # of the same depended packages.
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, systems, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      
      perSystem = { pkgs, system, ... }: {
        # packages = { };
        # devShells = { };
      };
      
      flake = {
        nixosConfigurations = let
          # Import our custom lib which merges helpers with nixpkgs.lib
          lib = import ./lib { lib = nixpkgs.lib; };
          
          # Import modules
          modules = lib.collectModules ./modules;
          
          # Import hosts
          hostConfigs = let
            hostDirs = builtins.attrNames (builtins.readDir ./hosts);
            
            getHostConfig = hostName:
              if builtins.pathExists (./hosts + "/${hostName}/default.nix")
              then import (./hosts + "/${hostName}/default.nix")
              else null;
              
            # Filter out null values and build host config map
            configs = builtins.listToAttrs (
              builtins.map (hostName: 
                let config = getHostConfig hostName;
                in if config != null
                   then { name = hostName; value = config; }
                   else null
              ) hostDirs
            );
          in configs;
          
          mkNixosConfiguration = hostName: hostConfig:
            nixpkgs.lib.nixosSystem {
              system = hostConfig.system;
              specialArgs = { inherit inputs lib; };
              modules = [
                {
                  networking.hostName = hostConfig.hostName;
                }
                
                hostConfig.config
                hostConfig.hardware
                
                home-manager.nixosModules.home-manager
              ]
              ++ modules;
            };
        in
          builtins.mapAttrs mkNixosConfiguration hostConfigs;
      };
    };
}
