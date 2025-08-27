{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.wofi;
in
{
  options.modules.desktop.wofi = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.wofi = {
        enable = true;
        settings = {
          # General
          show = "drun";
          prompt = "Search";
          normal_window = true;
          layer = "top";
          term = config.modules.desktop.apps.terminal.default;

          # Geometry
          width = "600px";
          height = "400px";
          location = "center";
          orientation = "vertical";
          halign = "fill";
          line_wrap = "off";
          dynamic_lines = false;

          # Images
          allow_markup = true;
          allow_images = true;
          image_size = 32;

          # Search
          matching_mode = "fuzzy";
          exec_search = false;
          hide_search = false;
          parse_search = false;
          insensitive = false;

          # Other
          hide_scroll = true;
          no_actions = true;
          sort_order = "default";
          gtk_dark = true;
          filter_rate = 100;

          # Keys
          key_expand = "Tab";
          key_exit = "Escape";
        };
      };

      xdg.configFile."wofi" = {
        source = ./config;
        recursive = true;
      };

      stylix.targets.wofi.enable = true;
    };
  };
}
