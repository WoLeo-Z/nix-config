{ lib, ... }:
final: prev:
lib.packagesFromDirectoryRecursive {
  callPackage = lib.callPackageWith (prev.pkgs // { inherit prev; });
  directory = ./.;
}
