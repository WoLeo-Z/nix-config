{
  lib,
  pkgs,
  inputs,
  ...
}:

{
  system.stateVersion = "24.11";
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
    inputs.nix-tree.packages."x86_64-linux".default

    # Misc
    which
    tree
    findutils
    nitch
  ];

  stylix.targets.console.enable = true;

  hardware.enableRedistributableFirmware = true;

  programs.nix-ld.enable = true;
}
