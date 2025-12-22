{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.games.lutris;
in
{
  options.modules.desktop.apps.games.lutris = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ lutris ]; };
}
