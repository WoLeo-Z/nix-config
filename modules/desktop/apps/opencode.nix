{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.opencode;
in
{
  options.modules.desktop.apps.opencode = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ opencode ]; };
}
