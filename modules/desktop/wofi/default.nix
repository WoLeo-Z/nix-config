{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.wofi;
in
{
  options.modules.desktop.wofi = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.wofi.enable = true;
      xdg.configFile."wofi" = {
        source = ./config;
        recursive = true;
      };

      stylix.targets.wofi.enable = true;
    };
  };
}
