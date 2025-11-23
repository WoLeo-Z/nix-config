{ lib, config, ... }:

with lib;
let
  cfg = config.modules.services.smartd;
in
{
  options.modules.services.smartd = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.smartd = {
      enable = true;
      notifications.systembus-notify.enable = true;
    };

    services.systembus-notify.enable = true;
  };
}
