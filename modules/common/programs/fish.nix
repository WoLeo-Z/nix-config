{
  programs.fish.enable = true;
  hm = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting # disable greeting
      '';
    };
    programs.starship.enableFishIntegration = true;
  };

  documentation.man.generateCaches = false; # Disable to save time when rebuilding

  # Fix: cannot open database `.../programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.
  programs.command-not-found.enable = false;
}
