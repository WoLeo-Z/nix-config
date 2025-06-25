{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.games.osu-lazer;
in
{
  options.modules.desktop.apps.games.osu-lazer = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ osu-lazer-bin ];
    };
  };
}
