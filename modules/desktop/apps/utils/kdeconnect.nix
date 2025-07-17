{
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.kdeconnect;
in
{
  options.modules.desktop.apps.utils.kdeconnect = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      # programs.kdeconnect = {
      #   enable = true;
      # };
      services.kdeconnect = {
        enable = true;
        indicator = true;
        # package = pkgs.gnomeExtensions.gsconnect; # For GNOME Shell
      };
    };
  };
}
