{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.earlyoom;
in
{
  options.modules.services.earlyoom = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
    };
  };
}
