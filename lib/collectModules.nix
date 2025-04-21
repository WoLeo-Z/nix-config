{ lib }:

let
  inherit (lib) attrNames filterAttrs hasSuffix flatten;

  collect = dir:
    let
      contents = builtins.readDir dir;

      nixFiles = filterAttrs (name: type: type == "regular" && hasSuffix ".nix" name) contents;
      subdirs = filterAttrs (name: type: type == "directory") contents;

      imported = map (name: dir + "/${name}") (attrNames nixFiles);
      nested = flatten (map (name: collect (dir + "/${name}")) (attrNames subdirs));
    in
      imported ++ nested;

in
  collect
