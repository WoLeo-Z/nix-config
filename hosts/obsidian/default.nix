{ ... }:

{
  networking.hostName = "obsidian";
  # system = "x86_64-linux";

  modules = {
    profiles = {
      user = "wol";
      role = "workstation";
      hardware = [
        "cpu/intel"
        "gpu/nvidia"
        "audio"
        "bluetooth"
        # "printing/wireless"
        "security-keys"
        # "mouse/increase-debounce-time"
        "mouse/button-remap"
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
          tsukimi.enable = true;
        };
        editors = {
          evince.enable = true;
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
          minecraft = {
            lunar-client.enable = true;
            prismlauncher.enable = true;
          };
          osu-lazer.enable = true;
          steam.enable = true;
        };
        android-studio.enable = true;
        bitwarden.enable = false;
        bottles.enable = true;
        claude-code.enable = false;
        codex.enable = true;
        flatpak.enable = false;
        nautilus.enable = true;
        nemo.enable = true;
        qemu.enable = false;
        telegram.enable = true;
        virtualbox.enable = false;
        wechat.enable = true;
      };
      develop = {
        flutter.enable = false;
        lg.enable = true;
      };
    };

    services = {
      earlyoom.enable = true;
      mediamtx.enable = false;
      mihomo.enable = true;
      openssh.enable = true;
      restic.enable = true;
      safeeyes.enable = true;
      smartd.enable = true;
      sunshine.enable = true;
      tailscale.enable = true;
      zerotierone.enable = true;
    };
  };

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
      "umask=0077"
    ];
  };

  # Networking
  networking.interfaces."enp5s0".wakeOnLan.enable = true;
  systemd.network.networks = {
    "20-wired" = {
      matchConfig = {
        Name = "enp*";
      };

      dhcpConfig.RouteMetric = 20;

      networkConfig = {
        DHCP = "no";
        IPv6AcceptRA = false;
        IPv6PrivacyExtensions = false;
      };

      # ipv6AcceptRAConfig = {
      #   UseAutonomousPrefix = true;
      #   Token = "::12ff:e0ff:fee0:1420";
      # };

      address = [
        "192.168.71.100/24"
        "240e:b8f:211:d700::100/64"
        "fe80::100/64"

        # "240e:b8f:211:d700:12ff:e0ff:fee0:1420/64"
      ];

      routes = [
        { Gateway = "192.168.71.1"; }

        {
          Gateway = "fe80::7a5:7cc9:26ef:39a";
          GatewayOnLink = true;
        }
      ];
    };

    "30-wireless" = {
      matchConfig = {
        Name = "wlan*";
      };

      dhcpConfig.RouteMetric = 30;

      networkConfig = {
        DHCP = "yes";
      };
    };
  };
}
