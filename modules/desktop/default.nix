{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop;
in
{
  options.modules.desktop = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    modules.desktop.fcitx5.enable = true;

    modules.desktop.greetd.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
