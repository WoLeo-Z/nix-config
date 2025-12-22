{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.libreoffice;
in
{
  options.modules.desktop.apps.editors.libreoffice = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable { user.packages = with pkgs; [ libreoffice ]; };
}
