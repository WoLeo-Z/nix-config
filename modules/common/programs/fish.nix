{ pkgs, ... }:

{
  user.shell = pkgs.fish;
  programs.fish = {
    enable = true;
    useBabelfish = true;

    interactiveShellInit = ''
      set -U fish_greeting # disable greeting
    '';
  };

  # Fix: cannot open database `.../programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.
  programs.command-not-found.enable = false;
}
