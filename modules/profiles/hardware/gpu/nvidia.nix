{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  hardware = config.modules.profiles.hardware;
in
mkIf (any (s: hasPrefix "gpu/nvidia" s) hardware) (mkMerge [
  {
    services.xserver.videoDrivers = mkDefault [ "nvidia" ];

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [ pkgs.vaapiVdpau ];
      };
      nvidia = {
        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver). Support is
        # limited to the Turing and later architectures. Full list of supported
        # GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+. Currently alpha-quality/buggy,
        # so false is currently the recommended setting.
        open = mkDefault true;
        # Save some idle watts.
        powerManagement.enable = true; # see NixOS/nixos-hardware#348
        modesetting.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    boot.kernelParams = [
      # Fix: kernel: spd5118 1-0053: PM: failed to resume async: error -6
      # TODO: Check if working
      # https://bbs.archlinux.org/viewtopic.php?id=300008
      # https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks#Preserve_video_memory_after_suspend
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"

      "nvidia.NVreg_DynamicPowerManagement=2" # slightly improve performance?
    ];

    # # Cajole Firefox into video-acceleration (or try).
    # modules.desktop.browsers.librewolf.settings = {
    #   "media.ffmpeg.vaapi.enabled" = true;
    #   "gfx.webrender.enabled" = true;
    # };

    # nixpkgs.overlays = [
    #   (self: super: {
    #     btop = super.btop.override {
    #       # GPU Support
    #       # https://github.com/aristocratos/btop/issues/426#issuecomment-2103598718
    #       cudaSupport = true;
    #     };
    #     obs-studio = super.obs-studio.override {
    #       cudaSupport = true;
    #     };
    #   })
    # ];
    nixpkgs.config.cudaSupport = true;
  }

  # (mkIf (config.modules.desktop.type == "wayland") {
  (mkIf true {
    # see NixOS/nixos-hardware#348
    environment.systemPackages = with pkgs; [
      libva
      # Fixes crashes in Electron-based apps?
      # libsForQt5.qt5ct
      # libsForQt5.qt5-wayland
    ];

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      WLR_NO_HARDWARE_CURSORS = "1";

      # May cause Firefox crashes
      GBM_BACKEND = "nvidia-drm";

      # If you face problems with Discord windows not displaying or screen
      # sharing not working in Zoom, remove or comment this:
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  })

  (mkIf (elem "gpu/nvidia/cuda" hardware) {
    environment = {
      systemPackages = with pkgs; [
        cudaPackages.cudatoolkit # required for CUDA support
      ];
      variables = {
        # CUDA
        CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";

        # $EXTRA_LDFLAGS and $EXTRA_CCFLAGS are sometimes necessary too, but I
        # set those in nix-shells instead.
      };
    };
  })
])
