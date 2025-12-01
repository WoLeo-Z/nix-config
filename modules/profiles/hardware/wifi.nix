{
  lib,
  config,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "wifi" s) hardware) {
    # iwd
    networking = {
      wireless.iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
        settings.General.AddressRandomization = "network";
        settings.General.AddressRandomizationRange = "full";
      };

      networkmanager.wifi.backend = "iwd";
    };
  })
]
