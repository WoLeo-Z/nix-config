{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.caelestia-shell;

  caelestia-shell = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  caelestia-cli = inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.default;

  wallpaperPathFile = pkgs.writeText "caelestia-shell-wallpaper-path" ''
    ${config.modules.desktop.appearance.wallpaper}
  '';
in
{
  options.modules.desktop.caelestia-shell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = [
      caelestia-shell
      caelestia-cli
      pkgs.libnotify # for notify-send
    ];

    hm = {
      xdg.configFile."caelestia" = {
        source = pkgs.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/caelestia-shell/config";
        recursive = true;
      };

      home.activation.initCaelestiaShellWallpaperPath = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        mkdir -p "${config.home'.stateDir}/caelestia/wallpaper"
        cp -n "${wallpaperPathFile}" "${config.home'.stateDir}/caelestia/wallpaper/path.txt"
      '';
    };

    systemd.user.services.caelestia-shell = {
      wantedBy = [ "graphical-session.target" ];
      unitConfig = {
        Description = "A very segsy desktop shell";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      serviceConfig = {
        ExecStart = "${lib.getExe caelestia-shell}";
        Restart = "on-failure";
      };
    };

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
  };
}
