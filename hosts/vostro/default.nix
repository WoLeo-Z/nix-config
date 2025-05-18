{ inputs, ... }:

{
  hostName = "vostro";
  system = "x86_64-linux";

  config = {
    modules = {
      profiles = {
        user = "wol";
      };

      desktop = {
        enable = true;
        appearance.enable = true;
        niri.enable = true;
        apps = {
          terminal = {
            default = "foot";
            foot.enable = true;
          };
          nautilus.enable = true;
          browsers = {
            google-chrome.enable = true;
          };
          media = {
            spotify.enable = true;
            cavalier.enable = true;
          };
          editors = {
            vscode.enable = true;
            zed = {
              enable = true;
              enableAI = true;
            };
          };
          utils = {
            gnome-control-center.enable = true;
          };
          flatpak.enable = true;
          telegram.enable = true;
        };
      };

      services = {
        ssh.enable = true;
        mihomo.enable = true;
      };

      system = {
        boot = {
          loader = {
            grub.enable = true;
          };
        };
      };
    };
  };

  hardware = {
    # Disable it to save time ...
    # boot.loader.grub.useOSProber = true; # Dual boot

    hardware.enableRedistributableFirmware = true;

    # CPU
    # imports = [ "${inputs.nixos-hardware}/common/cpu/intel/comet-lake" ];
    imports = [ inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only ];

    # GPU 1: AMD Radeon RX 550 / 550 Series [Discrete]
    hardware.amdgpu = {
      initrd.enable = true;
      amdvlk.enable = true;
      amdvlk.support32Bit.enable = true;
      # opencl.enable = true;
    };

    # Disable iGPU
    # GPU 2: Intel UHD Graphics 630 [Integrated]
    boot.blacklistedKernelModules = [ "i915" ];
    boot.kernelParams = [ "i915.modeset=0" ];

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true; # Showing battery charge of bluetooth devices
        };
      };
    };
    services.blueman.enable = true;
    hm.services.mpris-proxy.enable = true; # Using Bluetooth headset buttons to control media player

    # FileSystems
    boot.supportedFilesystems = [ "ntfs" ];

    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };

    fileSystems."/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "compress=zstd"
        "noatime"
      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT"; # sudo fatlabel /dev/vda1 BOOT
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };

    # Networking
    networking.interfaces.enp3s0.useDHCP = true;
    # networking.interfaces.wlp4s0.useDHCP = true;
  };
}
