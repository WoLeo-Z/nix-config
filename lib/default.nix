{ lib }:

let
  moduleDiscovery = import ./moduleDiscovery.nix { inherit lib; };
  modules = moduleDiscovery.importModules {
    dir = ./.;
    args = { inherit lib; };
  };
  customLib = builtins.foldl' (acc: m: acc // m) { } modules;
in
lib // customLib
