{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swaybg;
  wallpaper = config.modules.desktop.appearance.wallpaper;
in
{
  options.modules.desktop.swaybg = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    systemd.user.services.swaybg = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "Wallpaper tool for Wayland compositors";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      servicConfig = {
        ExecStart = "${lib.getExe pkgs.swaybg} --image ${wallpaper} --mode fill";
        Restart = "on-failure";
      };
    };
  };
}
