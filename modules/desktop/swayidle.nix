{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swayidle;

  # After resume, if Hyprlock is not unlocked for 60 seconds, system will automatically suspend.
  auto-suspend-after-resume = pkgs.writeShellScriptBin "auto-suspend-after-resume" ''
    ${lib.getExe' pkgs.coreutils "sleep"} 60
    if ${lib.getExe' pkgs.procps "pgrep"} "hyprlock" > /dev/null; then
      ${lib.getExe' pkgs.systemd "systemctl"} suspend
    fi
  '';
in
{
  options.modules.desktop.swayidle = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    modules.desktop.hyprlock.enable = true;

    hm.services.swayidle = {
      enable = true;
      extraArgs = lib.mkForce [ ]; # remove `-w` to avoid double lock bug
      events = [
        {
          event = "lock";
          command = "${lib.getExe pkgs.hyprlock}";
        }
        {
          event = "before-sleep";
          command = "${lib.getExe pkgs.hyprlock}";
        }
        {
          event = "after-resume";
          command = "${lib.getExe auto-suspend-after-resume}";
        }
      ];
      timeouts = [
        # {
        #   timeout = 300;
        #   command = "${lib.getExe pkgs.hyprlock}";
        # }
        # {
        #   timeout = 1800;
        #   command = "${lib.getExe' pkgs.systemd "systemctl"} suspend";
        # }
      ];
    };
  };
}
