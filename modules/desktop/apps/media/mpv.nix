{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.media.mpv;
in
{
  options.modules.desktop.apps.media.mpv = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm.programs.mpv = {
      enable = true;
    };
  };
}
