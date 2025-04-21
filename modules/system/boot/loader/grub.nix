{ lib, config, pkgs, ... }:

with lib;
let cfg = config.modules.system.boot.loader.grub;
in {
  options.modules.system.boot.loader.grub = {
    enable = mkEnableOption "Enable GRUB bootloader";
  };

  config = mkIf cfg.enable {
    boot.loader = {
      timeout = 3;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        device = "nodev";
      };
    };
  };
}
