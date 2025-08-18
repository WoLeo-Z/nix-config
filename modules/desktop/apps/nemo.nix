{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.nemo;
in
{
  options.modules.desktop.apps.nemo = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nemo-with-extensions
      xarchiver
    ];

    services.gvfs.enable = true;

    # Removable disk automounter
    hm.services.udiskie = {
      enable = true;
      tray = "never";
    };
    services.udisks2.enable = true;

    hm = {
      dconf.settings = {
        "org/nemo/preferences" = {
          show-advanced-permissions = true;
          show-full-path-titles = true;
          show-location-entry = false;

          default-folder-viewer = "icon-view"; # "list-view"
          default-zoom-level = "smaller";
          close-device-view-on-device-eject = "true";
          date-format = "iso";
          date-font-choice = "no-mono";
          show-reload-icon-toolbar = true;
          show-show-thumbnails-toolbar = true;
          show-open-in-terminal-toolbar = true;
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          show-hidden = false;
          sort-directories-first = true;
        };
      };
    };
  };
}
