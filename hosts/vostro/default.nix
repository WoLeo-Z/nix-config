{ ... }:

{
  hostName = "vostro";
  system = "x86_64-linux";

  config = {
    modules = {
      profiles = {
        user = "wol";
        hardware = [
          "cpu/intel"
          "gpu/amd"
          "gpu/disable-igpu"
          "audio"
          "bluetooth"
          "printing/wireless"
        ];
      };

      desktop = {
        enable = true;
        appearance.enable = true;
        niri.enable = true;
        apps = {
          terminal = {
            default = "alacritty";
            alacritty.enable = true;
            foot.enable = true;
            ghostty.enable = true;
            kitty.enable = true;
          };
          nautilus.enable = true;
          browsers = {
            firefox.enable = true;
            google-chrome.enable = true;
          };
          media = {
            spotify.enable = true;
            cavalier.enable = true;
            obs-studio.enable = false;
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
          games = {
            osu-lazer.enable = true;
          };
          flatpak.enable = false;
          telegram.enable = true;
          steam.enable = true;
          bottles.enable = true;
          bitwarden.enable = false;
        };
      };

      services = {
        openssh.enable = true;
        mihomo.enable = true;
        sunshine.enable = true;
        tailscale.enable = true;
      };
    };
  };

  hardware = {
    # Disable it to save time ...
    # boot.loader.grub.useOSProber = true; # Dual boot

    # CPU: Intel(R) Core(TM) i3-10100 (8) @ 4.30 GHz
    # GPU 1: AMD Radeon RX 550 / 550 Series [Discrete]
    # GPU 2 (Disabled): Intel UHD Graphics 630 [Integrated]
    # Bluetooth

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
    # networking.interfaces.enp3s0.useDHCP = true;
    # networking.interfaces.wlp4s0.useDHCP = true;
  };
}
