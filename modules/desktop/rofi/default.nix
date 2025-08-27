{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.rofi;

  rofi-launcher = pkgs.writeShellScriptBin "rofi-launcher" ''
    rofi -show drun -theme $HOME/.config/rofi/launcher/style.rasi
  '';
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
        package = pkgs.rofi-wayland;
      };

      home.packages = [
        rofi-launcher
      ];

      xdg.configFile."rofi" = {
        source = ./config;
        recursive = true;
      };

      stylix.targets.rofi.enable = true;
    };
  };
}
