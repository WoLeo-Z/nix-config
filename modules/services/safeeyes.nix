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
        After = [ "graphical-session.target" ];
      };

      serviceConfig = {
        ExecStart = lib.getExe pkgs.safeeyes;
      };
    };
  };
}
