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
      wireless.iwd.enable = true;
      networkmanager.wifi.backend = "iwd";
    };
  })
]
