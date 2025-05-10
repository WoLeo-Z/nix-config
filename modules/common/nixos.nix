{ lib, pkgs, ... }:

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

    # Networking
    wget
    curl
    dnsutils # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    nmap

    # Misc
    which
    tree
  ];
}
