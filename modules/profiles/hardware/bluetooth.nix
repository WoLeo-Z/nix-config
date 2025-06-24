{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "bluetooth" s) hardware) {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true; # Showing battery charge of bluetooth devices
        };
      };
    };
    services.blueman.enable = true;
    hm.services.mpris-proxy.enable = true; # Using Bluetooth headset buttons to control media player
  })
]
