{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.wireshark;
in
{
  options.modules.desktop.apps.utils.wireshark = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };

    user.extraGroups = [ "wireshark" ];
  };
}
