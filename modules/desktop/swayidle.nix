{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swayidle;
in
{
  options.modules.desktop.swayidle = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs = {
        swaylock.enable = true;
      };

      stylix.targets.swaylock.enable = true;

      services = {
        swayidle = {
          enable = true;
          # extraArgs = lib.mkForce [ ]; # remove `-w` to avoid double lock bug
          events = [
            {
              event = "lock";
              command = "${lib.getExe pkgs.swaylock} -fF";
            }
            {
              event = "before-sleep";
              command = "${lib.getExe pkgs.swaylock} -fF";
            }
          ];
          timeouts = [
            # {
            #   timeout = 300;
            #   command = "${lib.getExe pkgs.swaylock} -fF";
            # }
            # {
            #   timeout = 1800;
            #   command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
            # }
          ];
        };
      };
    };

    # security.pam.services.swaylock = { };
  };
}
