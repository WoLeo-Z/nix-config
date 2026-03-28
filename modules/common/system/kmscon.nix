{
  services.kmscon = {
    enable = true;
    hwRender = false; # fix: font blurry
    extraConfig = ''
      font-dpi=144
    '';
  };

  stylix.targets.kmscon.enable = true;
}
