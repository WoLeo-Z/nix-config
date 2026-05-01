{ ... }:

{
  networking.hostName = "obsidian";
  # system = "x86_64-linux";

  modules = {
    profiles = {
      user = "wol";
      roles = [
        "workstation"
        "cn"
      ];
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
          gpu-screen-recorder.enable = false;
          mpv.enable = true;
          obs-studio.enable = true;
          spotify.enable = true;
          tsukimi.enable = true;
        };
        editors = {
          libreoffice.enable = true;
          obsidian.enable = true;
          papers.enable = true;
          vscode.enable = true;
          zed.enable = true;
        };
        utils = {
          gnome-control-center.enable = false;
          kdeconnect.enable = false;
          motrix.enable = false;
          wireshark.enable = false;
        };
        games = {
          minecraft = {
            lunar-client.enable = false;
            prismlauncher.enable = true;
          };
          lutris.enable = true;
          osu-lazer.enable = true;
          steam.enable = true;
        };
        android-studio.enable = true;
        bitwarden.enable = false;
        blender.enable = false;
        bottles.enable = true;
        claude-code.enable = false;
        codex.enable = true;
        flatpak.enable = false;
        gnome-apps.enable = true;
        nautilus.enable = true;
        nemo.enable = true;
        qemu.enable = false;
        telegram.enable = true;
        virtualbox.enable = false;
        wechat.enable = false;
      };
    };

    services = {
      earlyoom.enable = true;
      easyeffects.enable = false;
      mediamtx.enable = false;
      mihomo.enable = true;
      openssh.enable = true;
      restic.enable = true;
      safeeyes.enable = true;
      smartd.enable = true;
      sunshine.enable = true;
      syncthing.enable = true;
      tailscale.enable = true;
      zerotierone.enable = false;
    };
  };

  # Disable it to save time ...
  # boot.loader.grub.useOSProber = true; # Dual boot

  # Host: B760M GAMING X AX
  # CPU: Intel(R) Core(TM) i5-14600KF (20) @ 5.30 GHz
  # GPU: NVIDIA GeForce RTX 5070 [Discrete]
  # Memory: 31.18 GiB
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
    options = [ "umask=0077" ];
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
        "192.168.0.66/24"
        "240e:b8f:2d0:af00::66/64"
        "fe80::66/64"

        # "240e:b8f:2d0:af00:12ff:e0ff:fee0:1420/128"
      ];

      routes = [
        { Gateway = "192.168.0.1"; }

        {
          Gateway = "fe80::108f:7cc9:26ef:533";
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
