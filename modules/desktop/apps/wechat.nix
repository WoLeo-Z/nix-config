{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.wechat;
in
{
  options.modules.desktop.apps.wechat = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ wechat-uos ]; };
}
