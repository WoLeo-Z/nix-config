{
  lib,
  inputs,
  ...
}:

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
        terminal = {
          default = "foot";
          foot.enable = true;
        };
        apps = {
          nautilus.enable = true;
          browsers = {
            google-chrome.enable = true;
          };
          media = {
            spotify.enable = true;
          };
          editors = {
            zed = {
              enable = true;
              enableAI = true;
            };
          };
          flatpak.enable = true;
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
    boot.loader.grub.useOSProber = true; # Dual boot

    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      inputs.nixos-hardware.nixosModules.common-gpu-amd
      inputs.nixos-hardware.nixosModules.common-pc-ssd
    ];

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

    swapDevices = [
      { device = "/dev/disk/by-label/swap"; }
    ];

    networking.interfaces.enp3s0.useDHCP = true;
    networking.interfaces.wlp4s0.useDHCP = true;
  };
}
