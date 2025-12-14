{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.blender;
in
{
  options.modules.desktop.apps.blender = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        blender
        # (blender.override { cudaSupport = true; })
      ];
    };
  };
}
