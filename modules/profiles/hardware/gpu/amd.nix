{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "gpu/amd" s) hardware) {
    hardware.amdgpu = {
      initrd.enable = true;
      # Disable AMDVLK to slightly improve performance (maybe?)
      amdvlk.enable = false;
      amdvlk.support32Bit.enable = false;
      # opencl.enable = true;
    };
  })
]
