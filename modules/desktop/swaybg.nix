{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swaybg;
  wallpaper = config.modules.desktop.appearance.image;
in
{
  options.modules.desktop.swaybg = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      systemd.user.services.swaybg = {
        Unit = {
          Description = "Wallpaper tool for Wayland compositors";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} --image ${wallpaper} --mode fill";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
