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
      stylix.targets.swaync.enable = true;
    };

    user.packages = with pkgs; [
      libnotify # provide notify-send
    ];
  };
}
