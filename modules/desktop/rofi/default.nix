{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.rofi;

  rofi-launcher = pkgs.writeShellScriptBin "rofi-launcher" ./launcher.sh;
  rofi-cliphist = pkgs.writeShellScriptBin "rofi-cliphist" ./cliphist.sh;
in
{
  options.modules.desktop.rofi = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
      };

      xdg.configFile."rofi" = {
        source = ./config;
        recursive = true;
      };

      stylix.targets.rofi.enable = true;
    };

    user.packages = [
      rofi-launcher
      rofi-cliphist
    ];
  };
}
