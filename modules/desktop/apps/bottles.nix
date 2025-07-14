{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.bottles;
in
{
  options.modules.desktop.apps.bottles = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ (bottles.override { removeWarningPopup = true; }) ];
    };
  };
}
