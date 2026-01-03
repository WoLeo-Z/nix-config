{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.easyeffects;
in
{
  options.modules.services.easyeffects = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ easyeffects ];

    systemd.user.services.easyeffects = {
      wantedBy = [ "graphical-session.target" ];

      unitConfig = {
        Description = "Easyeffects daemon";
      };

      serviceConfig = {
        ExecStart = "${pkgs.easyeffects}/bin/easyeffects --hide-window";
        ExecStop = "${pkgs.easyeffects}/bin/easyeffects --quit";
        KillMode = "mixed";
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutStopSec = 10;
      };
    };
  };
}
