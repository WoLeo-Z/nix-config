{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.greetd;
in
{
  options.modules.desktop.greetd = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          user = config.user.name;
          # command = "$HOME/.wayland-session";
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.tuigreet}"
            # "--cmd niri-session" # command to run
            # "--greeting 'lol'" # show custom text above login prompt
            "--time" # display the current date and time
            "--time-format '%A, %B %d, %Y - %I:%M:%S %p'" # custom strftime format for displaying date and time
            "--remember" # remember last logged-in username
            "--remember-session" # remember last selected session
            # "--user-menu" # allow graphical selection of users from a menu
            "--asterisks" # display asterisks when a secret is typed
          ];
        };
        initial_session = {
          user = config.user.name;
          command = "${config.user.home}/.wayland-session";
        };
      };
    };

    # greetd enables graphical-desktop enables speechd
    # disable speechd to save space
    services.speechd.enable = false;
  };
}
