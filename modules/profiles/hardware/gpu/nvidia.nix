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
        powerManagement.enable = true;
        modesetting.enable = true;
        # pinned to 575.64.05
        # https://github.com/NixOS/nixpkgs/blob/6024b4aa94589b07b38bca7c3013b44ce38a41dd/pkgs/os-specific/linux/nvidia-x11/default.nix#L83-L90
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "575.64.05";
          sha256_64bit = "sha256-hfK1D5EiYcGRegss9+H5dDr/0Aj9wPIJ9NVWP3dNUC0=";
          sha256_aarch64 = "sha256-GRE9VEEosbY7TL4HPFoyo0Ac5jgBHsZg9sBKJ4BLhsA=";
          openSha256 = "sha256-mcbMVEyRxNyRrohgwWNylu45vIqF+flKHnmt47R//KU=";
          settingsSha256 = "sha256-o2zUnYFUQjHOcCrB0w/4L6xI1hVUXLAWgG2Y26BowBE=";
          persistencedSha256 = "sha256-2g5z7Pu8u2EiAh5givP5Q1Y4zk4Cbb06W37rf768NFU=";
        };
      };
    };

    boot.kernelParams = [
      # FIXME: Doesn't work
      # Try to fix: kernel: spd5118 1-0053: PM: failed to resume async: error -6
      # My next GPU wont be NVIDIA.
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

    # TODO: remove this after NVIDIA fixed this
    # https://forums.developer.nvidia.com/t/570-release-feedback-discussion/321956/248?page=13
    environment.sessionVariables = {
      GSK_RENDERER = "ngl";
    };
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
