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

    nixpkgs.overlays = [
      (self: super: {
        btop = super.btop.override {
          # AMDGPU data is queried using the ROCm SMI library
          # https://github.com/aristocratos/btop/blob/1c2ab3f5b57a623d7781f7286050d70b1892b760/README.md#gpu-compatibility
          rocmSupport = true;
        };
      })
    ];

    hm.programs.btop.settings = {
      # Impact performance, disable
      rsmi_measure_pcie_speeds = false;
    };
  })
]
