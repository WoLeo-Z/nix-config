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
    hm = {
      home.packages = with pkgs; [
        obsidian
      ];
    };

    nixpkgs.overlays = [
      (self: super: {
        obsidian = super.obsidian.override {
          commandLineArgs = lib.constants.chromiumArgs; # Fix input method
        };
      })
    ];
  };
}
