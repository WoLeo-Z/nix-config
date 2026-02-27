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

  imports = [ inputs.dank-material-shell.nixosModules.dank-material-shell ];

  config = mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = true;
    };
  };
}
