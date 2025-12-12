{ lib, pkgs, ... }:

{
  time.timeZone = lib.mkDefault "Asia/Shanghai";
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  # i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];
  console.keyMap = lib.mkDefault "us";

  environment.systemPackages = with pkgs; [
    # Core
    git
    vim
    bat # better cat
    duf # better df
    fd # better find
    ripgrep # better grep
    zoxide # fast cd

    # Archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # System
    pciutils # lspci
    usbutils # lsusb
    dmidecode
    lshw
    lm_sensors # sensors

    # Nix
    nix-tree

    # Misc
    which
    tree
    findutils
    nitch
  ];

  # Immutable /etc overlay
  boot.initrd.systemd.enable = true;
  services.userborn.enable = true;
  system.etc.overlay = {
    enable = true;
    mutable = false;
  };
  environment.etc = {
    "NIXOS".text = "";
    "machine-id".text = "2a830309da54e3cc89231f02693ac238\n"; # `dbus-uuidgen`
  };
  # fix: avahi-daemon.service: Failed to set up special execution directory in /etc: Read-only file system
  systemd.services.avahi-daemon.serviceConfig = {
    ConfigurationDirectory = lib.mkForce [ ];
  };

  services.journald.extraConfig = ''
    SystemMaxUse=1G
  '';

  services.dbus.implementation = "broker";

  system.nixos-init.enable = true;

  documentation.enable = false;
  stylix.targets.console.enable = true;
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "24.11";
}
