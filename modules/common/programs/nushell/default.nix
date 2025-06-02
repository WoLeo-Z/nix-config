{
  hm = {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;
    };
    programs.starship.enableNushellIntegration = true;
  };
}
