{ lib, config, ... }:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkMerge [
  (mkIf (any (s: hasPrefix "cpu/intel" s) hardware) {
    hardware.cpu.intel.updateMicrocode = mkDefault config.hardware.enableRedistributableFirmware;
    boot.kernelParams = [ "intel_pstate=active" ];
  })

  # (mkIf (elem "cpu/intel/kaby-lake" hardware) {
  #   boot.kernelParams = [
  #     "i915.enable_fbc=1"
  #     "i915.enable_psr=2"
  #   ];
  # })
]
