{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.astal-shell;
  astal-shell = inputs.astal-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.modules.desktop.astal-shell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    # https://github.com/knoopx/nix/blob/c08cf87bdee72a3f2c10c6f5d2a4cde0c8aee601/modules/home-manager/wm/niri/astal-shell.nix

    systemd.user.services.astal-shell = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "Astal Shell";
        After = [ "graphical-session.target" ];
        Wants = [ "graphical-session.target" ];
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe astal-shell}";
        Restart = "on-failure";
        RestartSec = 3;
      };
    };
  };
}
