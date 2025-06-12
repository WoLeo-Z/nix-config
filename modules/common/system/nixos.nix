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
    fd

    # Archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # System
    pciutils # lspci
    usbutils # lsusb

    # Nix
    inputs.nix-tree.packages."x86_64-linux".default

    # Misc
    which
    tree
    findutils
  ];

  stylix.targets.console.enable = true;
}
