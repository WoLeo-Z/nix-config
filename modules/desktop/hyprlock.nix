{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.hyprlock;
in
{
  options.modules.desktop.hyprlock = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.hyprlock = {
        enable = true;
        settings = {
          general = {
            fail_timeout = 500;
          };

          background = {
            # all these options are taken from hyprland, see https://wiki.hypr.land/Configuring/Variables/#blur for explanations
            blur_size = 4;
            blur_passes = 3; # 0 disables blurring
            noise = 0.0117;
            contrast = 1.3000; # Vibrant!
            brightness = 0.8000;
            vibrancy = 0.2100;
            vibrancy_darkness = 0.0;
          };

          label = {
            # cmd[update:1000] echo "<b><big>$(date +"%H:%M")</big></b>"
            text = "cmd[update:1000] echo \"<b><big>$(${lib.getExe' pkgs.coreutils "date"} +\"%H:%M\")</big></b>\"";
            font_size = 112;
            font_family = config.stylix.fonts.monospace.name;
            shadow_passes = 3;
            shadow_size = 4;

            position = "0, 0";
            halign = "center";
            valign = "center";
          };

          input-field = {
            size = "250, 50";
            outline_thickness = 3;

            dots_size = 0.26; # Scale of input-field height, 0.2 - 0.8
            dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
            dots_center = true;

            rounding = 22;
            # outer_color = "$color0";
            # inner_color = "$color0";
            # font_color = "$color6";
            fade_on_empty = true;
            placeholder_text = "<i>Password...</i>"; # Text rendered in the input box when it's empty.

            position = "0, -130";
            halign = "center";
            valign = "center";
          };
        };
      };

      stylix.targets.hyprlock.enable = true;
    };
  };
}
