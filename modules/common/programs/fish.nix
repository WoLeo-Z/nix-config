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

  # Disable to save time when rebuilding
  documentation.man.generateCaches = false;
  hm.programs.man.generateCaches = false;

  # Fix: cannot open database `.../programs.sqlite' at /run/current-system/sw/bin/command-not-found line 13.
  programs.command-not-found.enable = false;
}
