{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.gnome-control-center;
in
{
  options.modules.desktop.apps.utils.gnome-control-center = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ gnome-control-center ];

    hm.xdg.desktopEntries.gnome-control-center = {
      name = "GNOME Settings";
      exec = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center";
      icon = "preferences-system";
      terminal = false;
      categories = [
        "GNOME"
        "GTK"
        "Settings"
        "X-GNOME-Settings-Panel"
      ];
      startupNotify = true;
    };
  };
}
