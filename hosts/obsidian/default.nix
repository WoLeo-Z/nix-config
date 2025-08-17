{ ... }:

{
  hostName = "obsidian";
  system = "x86_64-linux";

  config = {
    modules = {
      profiles = {
        user = "wol";
        role = "workstation";
        hardware = [
          "cpu/intel"
          "gpu/nvidia"
          "audio"
          "bluetooth"
          "printing/wireless"
          "security-keys"
          "mouse-fix"
          "rtw8852c-fix"
          "wifi"
        ];
      };

      desktop = {
        enable = true;
        appearance.enable = true;
        niri.enable = true;
        apps = {
          terminal = {
            default = "kitty";
            alacritty.enable = false;
            foot.enable = false;
            ghostty.enable = false;
            kitty.enable = true;
          };
          browsers = {
            firefox.enable = false;
            google-chrome.enable = true;
            zen-browser.enable = true;
          };
          media = {
            cavalier.enable = true;
            mpv.enable = true;
            obs-studio.enable = true;
            spotify.enable = true;
          };
          editors = {
            libreoffice.enable = true;
            obsidian.enable = true;
            vscode.enable = true;
            zed = {
              enable = false;
              enableAI = true;
            };
          };
          utils = {
            gnome-control-center.enable = false;
            kdeconnect.enable = false;
            motrix.enable = false;
            wireshark.enable = true;
          };
          games = {
            osu-lazer.enable = true;
          };
          android-studio.enable = false;
          bitwarden.enable = false;
          bottles.enable = true;
          flatpak.enable = false;
          nautilus.enable = true;
          steam.enable = true;
          telegram.enable = true;
        };
      };

      services = {
        apollo.enable = false;
        mediamtx.enable = false;
        mihomo.enable = true;
        openssh.enable = true;
        safeeyes.enable = true;
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

    # Fix: kernel: spd5118 1-0053: PM: failed to resume async: error -6
    boot.blacklistedKernelModules = [ "spd5118" ];

    # Not working?
    # https://bbs.archlinux.org/viewtopic.php?id=300008
    # boot.extraModprobeConfig = ''
    #   options nvidia NVreg_PreserveVideoMemoryAllocations=1
    # '';

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
  };
}
