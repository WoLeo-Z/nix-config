{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.obsidian;
in
{
  options.modules.desktop.apps.editors.obsidian = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      (obsidian.override {
        commandLineArgs = lib.constants.chromiumArgs; # Fix input method
      })
    ];
  };
}
