{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "audio" s) hardware) {
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

    # JamesDSP
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
          Restart = "no";
          RestartSec = 5;
        };
      };
    };
  })
]
