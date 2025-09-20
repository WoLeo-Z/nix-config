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

        # REVIEW: replace with pkgs.rofi when updated to 2.0.0
        # Rofi now officially supports Wayland!
        # https://github.com/davatorium/rofi/pull/2136
        package = pkgs.rofi;
      };

      home.packages = [
        rofi-launcher
        rofi-cliphist
      ];

      xdg.configFile."rofi" = {
        source = ./config;
        recursive = true;
      };

      stylix.targets.rofi.enable = true;
    };
  };
}
