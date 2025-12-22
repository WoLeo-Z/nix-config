{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.telegram;
in
{
  options.modules.desktop.apps.telegram = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # telegram-desktop
      ayugram-desktop
    ];
  };
}
