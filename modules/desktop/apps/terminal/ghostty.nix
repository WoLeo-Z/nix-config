{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.terminal.ghostty;
in
{
  options.modules.desktop.apps.terminal.ghostty = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.ghostty = {
        enable = true;
        settings = {
          window-padding-x = 5;
          window-padding-y = 3;
        };
      };

      stylix.targets.ghostty.enable = true;
    };
  };
}
