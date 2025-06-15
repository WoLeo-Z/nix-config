{ lib, inputs, ... }:

with lib;
let
  storeFileName =
    path:
    let
      # All characters that are considered safe. Note "-" is not
      # included to avoid "-" followed by digit being interpreted as a
      # version.
      safeChars =
        [
          "+"
          "."
          "_"
          "?"
          "="
        ]
        ++ lowerChars
        ++ upperChars
        ++ stringToCharacters "0123456789";

      empties = l: genList (x: "") (length l);

      unsafeInName = stringToCharacters (replaceStrings safeChars (empties safeChars) path);

      safeName = replaceStrings unsafeInName (empties unsafeInName) path;
    in
    "hm_" + safeName;
in
{
  # https://github.com/nix-community/home-manager/blob/c5f345153397f62170c18ded1ae1f0875201d49a/modules/files.nix#L84C5-L90C82
  mkOutOfStoreSymlink =
    path:
    let
      pathStr = toString path;
      name = storeFileName (baseNameOf pathStr);
    in
    inputs.nixpkgs.legacyPackages."x86_64-linux".runCommandLocal name { }
      ''ln -s ${escapeShellArg pathStr} $out'';
}
