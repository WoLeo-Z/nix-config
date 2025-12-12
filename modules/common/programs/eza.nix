{ lib, ... }:

let
  shellAliases =
    let
      command = lib.concatStringsSep " " [
        "eza"
        "--group-directories-first"
        "--header"
        "--time-style=long-iso"
        "--hyperlink"
        "--git"
        "--color=auto"
        "--icons=auto"
      ];
    in
    {
      l = "${command} -lh";
      ls = "${command}";
      la = "${command} -la";
      lt = "${command} --tree";
    };
in
{
  hm = {
    programs.eza = {
      enable = true;
      extraOptions = [
        "--group-directories-first"
        "--header"
        "--time-style=long-iso"
        "--hyperlink"
      ];
      git = true;
      colors = "auto";
      icons = "auto";
    };

    programs.bash.shellAliases = shellAliases;
    programs.fish.shellAliases = shellAliases;
    programs.nushell.shellAliases = shellAliases;
  };
}
