{ lib, pkgs, ... }:

{
  boot = {
    # Kernel

    # kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_cachyos-lto;
    # kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "nowatchdog"
      "pcie_aspm=off" # Fix: log spam: PCIe Bus Error ...
    ];

    initrd = {
      availableKernelModules = [
        "btrfs"
      ];
      kernelModules = [ ];
    };
  };

  # Bootloader
  boot.loader = {
    timeout = 3;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };

    # grub = {
    #   efiSupport = true;
    #   devices = [ "nodev" ];
    #   useOSProber = lib.mkDefault false;
    #   # extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
    #   # configurationName = "${host}";
    #   extraConfig = ''
    #     insmod kbd
    #     set keymap=us
    #   '';
    #   extraEntries = ''
    #     menuentry "Reboot" {
    #       reboot
    #     }
    #     menuentry "Poweroff" {
    #       halt
    #     }
    #     menuentry "UEFI Firmware Settings" {
    #       fwsetup
    #     }
    #   '';
    # };

    systemd-boot = {
      enable = true;
      editor = true;
      # we use Git for version control, so we don't need to keep too many generations.
      configurationLimit = lib.mkDefault 10;
      # pick the highest resolution for systemd-boot's console.
      consoleMode = lib.mkDefault "max";
    };
  };

  stylix.targets.grub.enable = true;
}
