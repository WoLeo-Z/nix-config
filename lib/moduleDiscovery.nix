{ lib }:

let
  inherit (lib)
    attrNames
    concatMap
    hasSuffix
    hasPrefix
    ;
in
rec {
  collectModulePaths =
    {
      dir,
      includeDefault ? false,
    }:
    let
      walk =
        currentDir:
        let
          contents = builtins.readDir currentDir;
          names = attrNames contents;
        in
        concatMap (
          name:
          let
            fileType = contents.${name};
            path = currentDir + "/${name}";
          in
          if hasPrefix "_" name then
            [ ]
          else if fileType == "directory" then
            walk path
          else if
            fileType == "regular" && hasSuffix ".nix" name && (includeDefault || name != "default.nix")
          then
            [ path ]
          else
            [ ]
        ) names;
    in
    walk dir;

  importModules =
    {
      dir,
      args,
      includeDefault ? false,
    }:
    map (path: import path args) (collectModulePaths {
      inherit dir includeDefault;
    });
}
