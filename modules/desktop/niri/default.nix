{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.niri;
  package = pkgs.niri;
in
{
  options.modules.desktop.niri = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs.niri = {
      enable = true;
      package = package;
    };

    modules.desktop.waybar.enable = true;
    modules.desktop.wofi.enable = true;
    modules.desktop.swayidle.enable = true;
    modules.desktop.swww.enable = true;
    modules.desktop.swaync.enable = true;
    modules.desktop.xwayland-satellite.enable = true;

    hm = {
      home.packages = with pkgs; [
        wlr-randr
        wl-clipboard
        wl-clip-persist
        cliphist
        brightnessctl
      ];
    };

    home'.configFile."niri/config.kdl".source = ./config.kdl;

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      config = {
        niri = {
          default = [
            "gnome"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Access" = [ "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
          "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-gnome
      ];
    };
  };
}
