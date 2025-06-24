{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "printing" s) hardware) {
    services.printing = {
      enable = true;
      startWhenNeeded = true;
      # logLevel = "debug";
    };
  })

  (mkIf (elem "printing/wireless" hardware) {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  })
]
