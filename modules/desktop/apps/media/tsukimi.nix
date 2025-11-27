{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.media.tsukimi;
in
{
  options.modules.desktop.apps.media.tsukimi = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm.home.packages = with pkgs; [ tsukimi ];
  };
}
