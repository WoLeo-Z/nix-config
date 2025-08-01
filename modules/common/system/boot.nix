{ lib, pkgs, ... }:

with lib;
{
  boot = {
    # Kernel

    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    # kernelPackages = pkgs.linuxPackages_cachyos;
    # kernelPackages = pkgs.linuxPackages_cachyos-lto;
    # kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      "nowatchdog"
      "modprobe.blacklist=iTCO_wdt" # watchdog for Intel
      "modprobe.blacklist=sp5100_tco" # watchdog for AMD
      "pcie_aspm=off" # Fix: log spam: PCIe Bus Error ...
    ];

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "btrfs"
      ];
      kernelModules = [ ];
    };
  };

  # Bootloader: Grub
  boot.loader = {
    timeout = 3;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = mkDefault false;
      # extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
      # configurationName = "${host}";
      extraConfig = ''
        insmod kbd
        set keymap=us
      '';
      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
        menuentry "UEFI Firmware Settings" {
          fwsetup
        }
      '';
    };
  };

  stylix.targets.grub.enable = true;
}
