{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.audio;
in
{
  options.modules.services.audio = {
    enable = mkEnableOption' { };
    jamesdsp.enable = mkEnableOption' { };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      security.rtkit.enable = true;
      user.extraGroups = [ "audio" ];

      user.packages = with pkgs; [
        alsa-utils # for CLI utilities
        pavucontrol # for GUI audio control
        pulseaudio # for "pactl"
      ];
    })

    (mkIf cfg.jamesdsp.enable {
      # FIXME: Hide tray icon in waybar
      hm = {
        home.packages = with pkgs; [ jamesdsp ];
        systemd.user.services.jamesdsp = {
          Unit = {
            Description = "JamesDSP daemon";
            Requires = [ "dbus.service" ];
            After = [ "graphical-session.target" ];
            PartOf = [
              "graphical-session.target"
              "pipewire.service"
            ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${lib.getExe pkgs.jamesdsp} --tray";
            ExecStop = "${lib.getExe' pkgs.procps "pkill"} jamesdsp";
            Restart = "on-failure";
            RestartSec = 5;
          };
        };
      };
    })
  ];
}
