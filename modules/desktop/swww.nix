{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.swww;
  wallpaper = config.modules.desktop.appearance.image;
  wallpaperDir = "${config.programs.nh.flake}/assets/wallpapers";

  change-wallpaper = pkgs.writeShellScriptBin "change-wallpaper" ''
    if [ -n "$1" ]; then
      # If the image path is given
      wallpaper="$1"
      if [[ ! -f "$wallpaper" ]]; then
        echo "The wallpaper file does not exist."
        exit 1
      fi
    else
      # Randomly select one in wallpaperDir
      wallpaper="$(find "${wallpaperDir}" -name '*.jpg' -o -name '*.png' | shuf -n1)"

    fi

    ${lib.getExe pkgs.swww} img "$wallpaper" \
      --transition-fps 240 \
      --transition-type "grow" \
      --transition-duration 0.5
  '';
in
{
  options.modules.desktop.swww = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      services.swww.enable = true;
      systemd.user.services.swww = {
        Service = {
          ExecStartPost = "${lib.getExe pkgs.swww} img ${wallpaper}";
        };
      };

      home.packages = [ change-wallpaper ];
    };
  };
}
