{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.vicinae;
in
{
  options.modules.desktop.apps.utils.vicinae = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ vicinae ];

    hm = {
      xdg.configFile."vicinae" = {
        source = ./config;
        recursive = true;
      };
    };

    # ref: https://github.com/vicinaehq/vicinae/blob/005bfe7cb81df9d3ab02bbe16e9b0e0e7b219e37/nix/module.nix#L189-L213
    systemd.user.services.vicinae = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "Vicinae server daemon";
        Documentation = [ "https://docs.vicinae.com" ];
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe' pkgs.vicinae "vicinae"} server";
        Restart = "always";
        RestartSec = 5;
        KillMode = "process";
      };

      # fix: Failed to start app: "Child process set up failed: execve: No such file or directory"
      path = [
        "/run/current-system/sw"
        "/etc/profiles/per-user/${config.user.name}"
      ];
    };
  };
}
