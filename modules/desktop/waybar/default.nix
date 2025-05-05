{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.modules.desktop.waybar;
in
{
  options.modules.desktop.waybar = {
    enable = mkEnableOption "Enable waybar";
  };

  config = mkIf cfg.enable {
    hm = {
      programs.waybar.enable = true;
      home.packages = with pkgs; [
        playerctl # mpris
      ];
    };

    home'.configFile."waybar" = {
      source = ./config;
      recursive = true;
    };
  };
}
