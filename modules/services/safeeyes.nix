{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.safeeyes;
in
{
  options.modules.services.safeeyes = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    systemd.user.services.safeeyes = {
      wantedBy = [ "graphical-session.target" ];

      unitConfig = {
        Description = "Safe Eyes";
        PartOf = [ "graphical-session.target" ];
        StartLimitIntervalSec = 350;
        StartLimitBurst = 30;
      };

      serviceConfig = {
        ExecStart = lib.getExe pkgs.safeeyes;
        Restart = "on-failure";
        RestartSec = 3;

        # HACK: prevent network errors (actually network shouldn't be required)
        ExecStartPre = "${lib.getExe' pkgs.coreutils "sleep"} 3";
        # HACK: ignore output noise "screen saver extension not supported"
        StandardOutput = "null";
      };
    };
  };
}
