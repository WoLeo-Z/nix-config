{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.xwayland-satellite;
in
{
  options.modules.desktop.xwayland-satellite = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home = {
        packages = with pkgs; [ xorg.xrandr ]; # some apps will crash without this
        # For some reason doesn't work, might be reset by niri
        # sessionVariables = {
        #   DISPLAY = ":42";
        # };
      };

      systemd.user = {
        services = {
          "xwayland-satellite" = {
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
            Unit = {
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
              # Before = [ "fcitx5.service" ];
            };
            Service = {
              ExecStart = "${getExe pkgs.xwayland-satellite} :42";
              Restart = "on-failure";
              StandardOutput = "null";
            };
          };
        };
      };
    };
  };
}
