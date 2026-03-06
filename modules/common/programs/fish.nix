{
  programs.fish.enable = true;
  hm = {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -U fish_greeting # disable greeting
      '';
    };
  };
}
