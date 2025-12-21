{
  lib,
  config,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.dank-material-shell;
in
{
  options.modules.desktop.dank-material-shell = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      imports = [ inputs.dank-material-shell.homeModules.dank-material-shell ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;
      };
    };
  };
}
