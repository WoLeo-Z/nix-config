{
  hostName = "vm";
  system = "x86_64-linux";

  config = {
    modules = {
      profiles = {
        user = "wol";
        hardware = [ "qemu-guest" ];
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
        openssh.enable = true;
        mihomo.enable = true;
      };
    };
  };

  hardware = {
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
