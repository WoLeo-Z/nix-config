{ lib, runCommandLocal }:

path:

let
  storeFileName =
    fileName:
    let
      safeChars = [
        "+"
        "."
        "_"
        "?"
        "="
      ]
      ++ lib.lowerChars
      ++ lib.upperChars
      ++ lib.stringToCharacters "0123456789";

      empties = l: lib.genList (_: "") (builtins.length l);

      unsafeInName = lib.stringToCharacters (lib.replaceStrings safeChars (empties safeChars) fileName);
      safeName = lib.replaceStrings unsafeInName (empties unsafeInName) fileName;
    in
    "hm_" + safeName;

  pathStr = toString path;
  name = storeFileName (baseNameOf pathStr);
in
runCommandLocal name { } "ln -s ${lib.escapeShellArg pathStr} $out"
