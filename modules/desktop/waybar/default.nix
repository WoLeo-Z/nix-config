{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.waybar;
in
{
  options.modules.desktop.waybar = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };

      home.packages = with pkgs; [
        playerctl # mpris
      ];

      # stylix.targets.waybar.enable = true;
    };

    services.power-profiles-daemon.enable = true;

    home'.configFile."waybar" = {
      source = ./config;
      recursive = true;
    };
  };
}
