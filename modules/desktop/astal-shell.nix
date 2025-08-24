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
in
{
  options.modules.desktop.astal-shell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    # https://github.com/knoopx/nix/blob/c08cf87bdee72a3f2c10c6f5d2a4cde0c8aee601/modules/home-manager/wm/niri/astal-shell.nix

    nixpkgs.overlays = [ inputs.astal-shell.overlays.default ];

    hm = {
      home.packages = with pkgs; [
        astal-shell
      ];

      systemd.user.services.astal-shell = {
        Unit = {
          Description = "Astal Shell";
          After = [ "graphical-session.target" ];
          Wants = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.astal-shell}/bin/astal-shell";
          Restart = "on-failure";
          RestartSec = 3;
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
