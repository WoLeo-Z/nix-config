{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.nautilus;
in
{
  options.modules.desktop.apps.nautilus = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nautilus ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = config.modules.desktop.apps.terminal.default;
    };

    services.tumbler.enable = true; # A D-Bus thumbnailer service.
    # services.gnome.sushi.enable = true; # To preview files in Nautilus
    services.gvfs.enable = true; # Virtual Filesystem support library

    # Removable disk automounter
    hm.services.udiskie = {
      enable = true;
      tray = "never";
    };
    services.udisks2.enable = true;

    hm = {
      dconf.settings = {
        "org/gnome/nautilus/icon-view" = {
          captions = [
            "none"
            "none"
            "none"
          ];
        };
        "org/gnome/nautilus/list-view" = {
          # default-zoom-level = "small";

          # use-tree-view = true;
        };
        "org/gnome/nautilus/preferences" = {
          default-folder-viewer = "list-view";
          # click-policy = "single";

          show-create-link = true;
          show-delete-permanently = true;

          recursive-search = "local-only";
          show-image-thumbnails = "local-only";
          show-directory-item-counts = "local-only";

          date-time-format = "simple";
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          show-hidden = false;
          sort-directories-first = true;
        };
      };

      xdg.mimeApps =
        let
          value = "org.gnome.Nautilus.desktop";

          associations = builtins.listToAttrs (
            map (name: { inherit name value; }) [
              "inode/directory"

              # We use File Roller for compressed files
              # "application/x-7z-compressed"
              # "application/x-7z-compressed-tar"
              # "application/x-bzip"
              # "application/x-bzip-compressed-tar"
              # "application/x-compress"
              # "application/x-compressed-tar"
              # "application/x-cpio"
              # "application/x-gzip"
              # "application/x-lha"
              # "application/x-lzip"
              # "application/x-lzip-compressed-tar"
              # "application/x-lzma"
              # "application/x-lzma-compressed-tar"
              # "application/x-tar"
              # "application/x-tarz"
              # "application/x-xar"
              # "application/x-xz"
              # "application/x-xz-compressed-tar"
              # "application/zip"
              # "application/gzip"
              # "application/bzip2"
              # "application/x-bzip2-compressed-tar"
              # "application/vnd.rar"
              # "application/zstd"
              # "application/x-zstd-compressed-tar"
            ]
          );
        in
        {
          # associations.added = associations;
          defaultApplications = associations;
        };
    };
  };
}
