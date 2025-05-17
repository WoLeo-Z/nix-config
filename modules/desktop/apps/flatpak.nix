{
  lib,
  config,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.flatpak;

  untrustedFilesystemsOverride = [
    "xdg-public-share"
    "!xdg-desktop"
    "!xdg-documents"
    "!xdg-download"
    "!xdg-music"
    "!xdg-pictures"
    "!xdg-templates"
    "!xdg-videos"
  ];
in
{
  options.modules.desktop.apps.flatpak = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.flatpak.enable = true;

    hm = {
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      home.shellAliases = {
        "flatpak" = "flatpak --user";
      };

      # Fix: Installed flatpak apps .desktop files
      # https://github.com/gmodena/nix-flatpak/issues/31
      xdg.systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "${config.user.home}/.local/share/flatpak/exports/share"
      ];

      services.flatpak = {
        overrides = {
          global = {
            Context = {
              filesystems = [
                "/nix/store:ro"

                "xdg-config/fontconfig:ro;"
                # "xdg-data/fonts:ro"
                # "xdg-data/icons:ro"
                "/run/current-system/sw/share/X11/fonts:ro;"
              ];

              unset-environment = [
                "VK_DRIVER_FILES"
                "__EGL_VENDOR_LIBRARY_FILENAMES"
              ];
            };
          };

          # "com.discordapp.Discord" = {
          #   Context = {
          #     sockets = [ "wayland" ];
          #   };
          # };

          # "com.qq.QQ" = {
          #   Context = {
          #     filesystems = untrustedFilesystemsOverride;
          #     sockets = [ "!wayland" ];
          #   };
          #   Environment = {
          #     GTK_IM_MODULE = "fcitx";
          #   };
          # };

          # "com.spotify.Client" = {
          #   Context = {
          #     sockets = [ "wayland" ];
          #   };
          # };
        };

        packages = [
          "com.github.tchx84.Flatseal"
        ];

        uninstallUnmanaged = true;
        uninstallUnused = true;

        update = {
          onActivation = false;
          auto = {
            enable = true;
            onCalendar = "weekly";
          };
        };
      };
    };
    # stylix.targets.gtk.flatpakSupport.enable = false;
  };
}
