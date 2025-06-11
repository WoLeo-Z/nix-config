{ lib, pkgs, ... }:

with lib;
{
  boot = {
    # Kernel

    # kernelPackages = pkgs.linuxPackages
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.linuxPackages_cachyos-lto;

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

    # Bootloader: Grub
    loader = {
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";

        useOSProber = mkDefault false;

        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
      };
    };
  };

  stylix.targets.grub.enable = true;
}
