{
  hm = {
    programs.starship = {
      enable = true;
      enableNushellIntegration = true;
    };
  };

  home'.configFile."starship.toml".source = ./starship.toml;
}
