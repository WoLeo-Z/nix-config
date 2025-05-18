{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.terminal.foot;
in
{
  options.modules.desktop.apps.terminal.foot = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        libsixel # image support in foot
      ];

      programs.foot = {
        enable = true;
        server.enable = true;
        settings = {
          # https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
          main = {
            dpi-aware = mkForce "yes";
            # font = "JetBrainsMono Nerd Font:size=12";
          };
          scrollback = {
            lines = 10000;
          };
          key-bindings = {
            # Use Control+C to send SIGINT
            clipboard-copy = "Control+c XF86Copy";
            clipboard-paste = "Control+v XF86Paste";
          };
        };
      };

      stylix.targets.foot.enable = true;
    };
  };
}
