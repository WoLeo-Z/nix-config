{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "security-keys" s) hardware) {
    services.pcscd.enable = true; # Smart card (CCID) protocols
  })
]
