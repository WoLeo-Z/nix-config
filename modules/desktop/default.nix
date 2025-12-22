{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    modules.desktop.fcitx5.enable = true;

    modules.desktop.greetd.enable = true;

    hm = {
      home.sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
    };

    systemd.user.services."polkit-gnome".unitConfig = {
      After = [ "graphical-session.target" ];
    };

    security = {
      polkit.enable = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      tumbler.enable = true; # A D-Bus thumbnailer service.
      libinput.enable = true;
    };

    hm.home.packages = with pkgs; [
      # Audio Processing
      ffmpeg
      id3v2
    ];
  };
}
