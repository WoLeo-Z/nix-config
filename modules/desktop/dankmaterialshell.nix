{
  lib,
  config,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.dankmaterialshell;
in
{
  options.modules.desktop.dankmaterialshell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      imports = [
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      ];

      programs.dankMaterialShell = {
        enable = true;
        enableSystemd = true;
      };
    };
  };
}
