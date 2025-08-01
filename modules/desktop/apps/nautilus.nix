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
    environment.systemPackages = with pkgs; [
      nautilus
      xarchiver
    ];

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = config.modules.desktop.apps.terminal.default;
    };

    # services.gnome.sushi.enable = true; # To preview files in Nautilus
    services.gvfs.enable = true;

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
    };
  };
}
