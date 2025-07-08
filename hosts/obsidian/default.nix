{ ... }:

{
  hostName = "obsidian";
  system = "x86_64-linux";

  config = {
    modules = {
      profiles = {
        user = "wol";
        hardware = [
          "cpu/intel"
          "gpu/nvidia"
          "audio"
          "bluetooth"
          "printing/wireless"
          "security-keys"
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
            cavalier.enable = true;
            mpv.enable = true;
            obs-studio.enable = false;
            spotify.enable = true;
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

    # CPU: (TODO)
    # GPU 1: (TODO)
    # WiFi + Bluetooth

    # Sensor it8622-isa-0a40
    boot.kernelModules = [
      "coretemp"
      "it87"
    ];
    boot.extraModprobeConfig = ''
      options it87 ignore_resource_conflict=1 force_id=0x8622
    '';
    # boot.kernelParams = [ "acpi_enforce_resources=lax" ]; # no need

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
