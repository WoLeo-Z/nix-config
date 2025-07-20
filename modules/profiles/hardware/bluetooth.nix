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
        # https://github.com/bluez/bluez/blob/master/src/main.conf
        General = {
          ControllerMode = "bredr"; # "dual", "bredr", "le"
          Experimental = true; # Showing battery charge of bluetooth devices
          # KernelExperimental = true;
        };
      };
    };
    services.blueman.enable = true;
    hm.services.mpris-proxy.enable = true; # Using Bluetooth headset buttons to control media player
  })
]
