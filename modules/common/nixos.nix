{ pkgs, ... }:

{
  system.stateVersion = "24.11";
  networking.networkmanager.enable = true;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "zh_CN.UTF-8/UTF-8" ];

  environment.systemPackages = with pkgs; [
    # Core
    git
    neovim

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
