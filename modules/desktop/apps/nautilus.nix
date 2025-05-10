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
    environment.systemPackages = [ pkgs.nautilus ];

    programs.nautilus-open-any-terminal = {
      # FIXME: not working?
      enable = true;
      terminal = "foot";
    };

    services.gnome.sushi.enable = true;

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
          # default-folder-viewer = "list-view";
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
