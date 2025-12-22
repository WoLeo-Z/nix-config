{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.motrix;
in
{
  options.modules.desktop.apps.utils.motrix = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ motrix ];

    # hm.xdg.desktopEntries.motrix = {
    #   name = "Motrix";
    #   exec = "motrix";
    #   icon = "preferences-system";
    #   terminal = false;
    #   categories = [
    #     "Download Manager"
    #   ];
    #   startupNotify = true;
    # };
  };
}
