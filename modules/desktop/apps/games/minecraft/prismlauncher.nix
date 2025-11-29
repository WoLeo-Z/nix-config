{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.games.minecraft.prismlauncher;
in
{
  options.modules.desktop.apps.games.minecraft.prismlauncher = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ prismlauncher ];
    };
  };
}
