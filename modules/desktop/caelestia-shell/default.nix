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

  caelestia-shell = inputs.caelestia-shell.packages."x86_64-linux".default;
  caelestia-cli = inputs.caelestia-cli.packages."x86_64-linux".default;

  wallpaperPathFile = pkgs.writeText "caelestia-shell-wallpaper-path" ''
    ${config.modules.desktop.appearance.image}
  '';
in
{
  options.modules.desktop.caelestia-shell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = [
        caelestia-shell
        caelestia-cli
      ];

      systemd.user.services.caelestia-shell = {
        Unit = {
          Description = "A very segsy desktop shell";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe caelestia-cli} shell";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      xdg.configFile."caelestia" = {
        source = mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/caelestia-shell/config";
        recursive = true;
      };

      home.activation.initCaelestiaShellWallpaperPath = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        mkdir -p "${config.home'.stateDir}/caelestia/wallpaper"
        cp -n "${wallpaperPathFile}" "${config.home'.stateDir}/caelestia/wallpaper/path.txt"
      '';
    };

    services.power-profiles-daemon.enable = true;
  };
}
