{ lib, ... }:

{
  hostName = "vm";
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
            vscode.enable = true;
            zed = {
              enable = true;
              enableAI = true;
            };
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

    # TODO: Remove this for vm. Use key auth instead.
    services.openssh.settings.PasswordAuthentication = lib.mkForce true;
  };

  hardware = {
    # QEMU Guest TODO: Modularize this
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    # "/nix/var/nix/profiles/per-user/root/channels/nixos/nixos/modules/profiles/qemu-guest.nix"
    # Common configuration for virtual machines running under QEMU (using virtio).
    boot.initrd.availableKernelModules = [
      "virtio_net"
      "virtio_pci"
      "virtio_mmio"
      "virtio_blk"
      "virtio_scsi"
      "9p"
      "9pnet_virtio"
    ];
    boot.initrd.kernelModules = [
      "virtio_balloon"
      "virtio_console"
      "virtio_rng"
      "virtio_gpu"
    ];

    # boot.supportedFilesystems = [ "ntfs" ];

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

    swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

    networking.interfaces.enp1s0.useDHCP = true;

    # Try to mount shared flake folder
    boot.postBootCommands = ''
      mkdir -p /mnt/flake
      mount -t virtiofs flake /mnt/flake || true
      if mountpoint -q /mnt/flake; then
        rm -rf /etc/nixos
        ln -sf /mnt/flake /etc/nixos
      fi
    '';
  };
}
