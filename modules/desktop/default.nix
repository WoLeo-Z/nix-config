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
      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = config.modules.profiles.user;
            # command = "$HOME/.wayland-session";
            command =
              "${lib.getExe pkgs.greetd.tuigreet}"
              # + " --cmd niri-session" # command to run
              # + " --greeting 'lol'" # show custom text above login prompt
              + " --time" # display the current date and time
              + " --time-format '%A, %B %d, %Y - %I:%M:%S %p'" # custom strftime format for displaying date and time
              + " --remember" # remember last logged-in username
              + " --remember-session" # remember last selected session
              # + " --user-menu" # allow graphical selection of users from a menu
              + " --asterisks" # display asterisks when a secret is typed
            ;
          };
        };
      };
      # greetd enables graphical-desktop enables speechd
      # disable speechd to save space
      speechd.enable = false;

      gnome.gnome-keyring.enable = true;
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

    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      # jetbrains-mono
      nerd-fonts.jetbrains-mono
      material-icons
    ];

    hm.home.packages = with pkgs; [
      baobab # Disk Usage Analyzer
    ];
  };
}
