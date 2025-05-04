{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.wofi;
in
{
  options.modules.desktop.wofi = {
    enable = mkEnableOption "Enable wofi";
  };

  config = mkIf cfg.enable {
    home = {
      programs.wofi.enable = true;
      xdg.configFile."wofi" = {
        source = ./config;
        recursive = true;
      };
    };
  };
}
