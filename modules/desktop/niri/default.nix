{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.niri;
  package = pkgs.niri-unstable;
in
{
  imports = [
    inputs.niri.nixosModules.niri
  ];

  options.modules.desktop.niri = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    # For pkgs.niri-unstable
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];

    programs.niri = {
      enable = true;
      package = package;
    };

    modules.desktop.xwayland-satellite.enable = true;

    # Astal Shell
    # modules.desktop.astal-shell.enable = true;
    # modules.desktop.swww.enable = true;
    # modules.desktop.swaync.enable = true;
    # modules.desktop.swayidle.enable = true;

    # Caelestia Shell
    # modules.desktop.caelestia-shell.enable = true;
    # modules.desktop.swayidle.enable = true;

    # Caelestia Shell
    modules.desktop.dankmaterialshell.enable = true;
    modules.desktop.swayidle.enable = true;

    # Waybar
    # modules.desktop.waybar.enable = true;
    # modules.desktop.swww.enable = true;
    # modules.desktop.swaync.enable = true;
    # modules.desktop.swayidle.enable = true;

    # modules.desktop.rofi.enable = true;
    # modules.desktop.wofi.enable = true;
    modules.desktop.apps.utils.vicinae.enable = true;

    hm = {
      home.packages = with pkgs; [
        wlr-randr
        wl-clipboard
        wl-clip-persist
        cliphist
        brightnessctl
      ];
    };

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

    # Disable KDE polkit agent. We use GNOME polkit agent.
    # https://github.com/sodiboo/niri-flake/blob/9b0c42a79bd092971e183d102365e549e4280002/README.md?plain=1#L126
    systemd.user.services.niri-flake-polkit.enable = false;

    # Environment variables for Wayland
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # for Chromium and Electron
      MOZ_ENABLE_WAYLAND = "1"; # for Firefox
      QT_QPA_PLATFORM = "wayland"; # for Qt

      # Chromium/Electron
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

    # For greetd initial_session
    hm.home.file.".wayland-session" = {
      source = "${lib.getExe' package "niri-session"}";
      executable = true;
    };
  };
}
