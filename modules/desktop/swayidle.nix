{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swayidle;

  # After resume, if not unlocked for 60 seconds, system will automatically suspend.
  auto-suspend-after-resume = pkgs.writeShellScriptBin "auto-suspend-after-resume" ''
    ${lib.getExe' pkgs.coreutils "sleep"} 60
    if ${lib.getExe' pkgs.procps "pgrep"} "swaylock" > /dev/null; then
      ${lib.getExe' pkgs.systemd "systemctl"} suspend
    fi
  '';
in
{
  options.modules.desktop.swayidle = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    modules.desktop.swaylock.enable = true;

    hm.services.swayidle = {
      enable = true;
      events = [
        {
          event = "lock";
          command = "${lib.getExe pkgs.swaylock} -fF";
        }
        {
          event = "before-sleep";
          command = "${lib.getExe pkgs.swaylock} -fF";
        }
        {
          event = "after-resume";
          # # use "&" run it in background, so swayidle won't wait for it
          command = "${lib.getExe auto-suspend-after-resume} &";
        }
      ];
      timeouts = [
        # {
        #   timeout = 300;
        #   command = "${lib.getExe pkgs.swaylock}";
        # }
        # {
        #   timeout = 1800;
        #   command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        # }
      ];
    };
  };
}
