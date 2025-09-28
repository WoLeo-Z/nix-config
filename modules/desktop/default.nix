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

      services = {
        gnome-keyring.enable = lib.mkDefault (!config.services.gnome.gnome-keyring.enable);
        polkit-gnome.enable = true;
      };

      systemd.user.services."polkit-gnome".Unit.After = [ "graphical-session.target" ];
    };

    security = {
      polkit.enable = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      tumbler.enable = true; # A D-Bus thumbnailer service.
      libinput.enable = true;
    };

    # Borrowed from https://github.com/sjcobb2022/nixos-config/blob/main/hosts/common/optional/greetd.nix
    # this is a life saver.
    # literally no documentation about this anywhere.
    # might be good to write about this...
    # https://www.reddit.com/r/NixOS/comments/u0cdpi/tuigreet_with_xmonad_how/
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInput = "tty";
      StandardOutput = "tty";
      StandardError = "journal"; # Without this errors will spam on screen
      # Without these bootlogs will spam on screen
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    hm.home.packages = with pkgs; [
      baobab # Disk Usage Analyzer

      # Audio Processing
      ffmpeg
      id3v2
    ];
  };
}
