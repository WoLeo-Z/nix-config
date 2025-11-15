{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.games.minecraft.lunar-client;
in
{
  options.modules.desktop.apps.games.minecraft.lunar-client = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ lunar-client ];
    };
  };
}
