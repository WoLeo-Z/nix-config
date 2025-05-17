{ lib, ... }:

let
  collectModules = (import ./collectModules.nix { inherit lib; }).collectModules;
  allFiles = collectModules ./.;
  moduleFiles = lib.filter (f: !lib.strings.hasSuffix "default.nix" f) allFiles;
  modules = lib.map (path: import path { inherit lib; }) moduleFiles;
  customLib = builtins.foldl' (acc: m: acc // m) { } modules;
in
lib // customLib
