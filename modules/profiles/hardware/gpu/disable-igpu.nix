{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "gpu/disable-igpu" s) hardware) {
    boot.blacklistedKernelModules = [ "i915" ];
    boot.kernelParams = [ "i915.modeset=0" ];
  })
]
