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

    # fix: desktop notification
    # https://github.com/NixOS/nixpkgs/pull/375649
    # REVIEW: remove after NixOS/nixpkgs#375649 has been merged
    systemd.services.earlyoom.serviceConfig.DynamicUser = mkDefault (
      !config.services.earlyoom.enableNotifications || config.services.dbus.implementation != "dbus"
    );
  };
}
