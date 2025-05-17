{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swaync;
in
{
  options.modules.desktop.swaync = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      services.swaync = {
        enable = true;
      };

      home.packages = with pkgs; [
        libnotify # provide notify-send
      ];

      stylix.targets.swaync.enable = true;
    };
  };
}
