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

    environment.systemPackages = with pkgs; [ xwayland-satellite ];

    # Astal Shell
    # modules.desktop.astal-shell.enable = true;
    # modules.desktop.swww.enable = true;
    # modules.desktop.swaync.enable = true;
    # modules.desktop.swayidle.enable = true;

    # Caelestia Shell
    # modules.desktop.caelestia-shell.enable = true;
    # modules.desktop.swayidle.enable = true;

    # Dank Material Shell
    modules.desktop.dank-material-shell.enable = true;
    modules.desktop.swayidle.enable = true;

    # Noctalia Shell
    # modules.desktop.noctalia-shell.enable = true;

    # Waybar
    # modules.desktop.waybar.enable = true;
    # modules.desktop.swww.enable = true;
    # modules.desktop.swaync.enable = true;
    # modules.desktop.swayidle.enable = true;

    # modules.desktop.rofi.enable = true;
    # modules.desktop.wofi.enable = true;
    modules.desktop.apps.utils.vicinae.enable = true;

    user.packages = with pkgs; [
      wlr-randr
      wl-clipboard
      wl-clip-persist
      cliphist
      brightnessctl
    ];

    home'.configFile."niri/config.kdl".source =
      mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/desktop/niri/config.kdl";

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

    # Environment variables for Wayland
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1"; # Firefox
      QT_QPA_PLATFORM = "wayland"; # Qt
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Qt
      SDL_VIDEODRIVER = "wayland"; # SDL

      # Chromium/Electron
      NIXOS_OZONE_WL = "1"; # https://wiki.nixos.org/wiki/Wayland#Electron_and_Chromium
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      CHROMIUM_FLAGS = lib.concatStringsSep " " [
        "--enable-features=UseOzonePlatform,VaapiVideoDecoder,VaapiVideoEncoder,WaylandWindowDecorations"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
        "--disable-gpu-sandbox"
        "--enable-zero-copy"
        "--ignore-gpu-blacklist"
        "--enable-gpu-rasterization"
      ];
    };

    # No CSD (Client-Side Decorations) for GTK Apps
    hm.dconf.settings."org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:";
    };

    # For greetd initial_session
    hm.home.file.".wayland-session" = {
      source = "${lib.getExe' package "niri-session"}";
      executable = true;
    };
  };
}
