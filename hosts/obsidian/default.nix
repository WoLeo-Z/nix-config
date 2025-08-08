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
          nautilus.enable = true;
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
          flatpak.enable = false;
          telegram.enable = true;
          steam.enable = true;
          bottles.enable = true;
          bitwarden.enable = false;
        };
      };

      services = {
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

    # networking = {
    #   interfaces.enp4s0 = {
    #     ipv4.addresses = [
    #       {
    #         address = "192.168.71.100";
    #         prefixLength = 24;
    #       }
    #     ];
    #   };
    #   defaultGateway = {
    #     address = "192.168.71.1";
    #     interface = "enp4s0";
    #   };
    # };

    systemd.network.networks."20-wired" = {
      matchConfig.Name = "enp4s0";
      address = [ "192.168.71.100/24" ];
      gateway = [ "192.168.71.1" ];
      # dns = [
      #   "8.8.8.8"
      #   "1.1.1.1"
      # ];
    };
  };
}
