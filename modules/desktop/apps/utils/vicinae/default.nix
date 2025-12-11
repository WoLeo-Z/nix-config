{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.utils.vicinae;
in
{
  options.modules.desktop.apps.utils.vicinae = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ pkgs.vicinae ];

      xdg.configFile."vicinae" = {
        source = ./config;
        recursive = true;
      };

      # https://github.com/nix-community/home-manager/blob/13cc1efd78b943b98c08d74c9060a5b59bf86921/modules/programs/vicinae.nix#L245-L265
      systemd.user.services.vicinae = {
        Unit = {
          Description = "Vicinae server daemon";
          Documentation = [ "https://docs.vicinae.com" ];
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          EnvironmentFile = pkgs.writeText "vicinae-env" ''
            USE_LAYER_SHELL=1
          '';
          Type = "simple";
          ExecStart = "${lib.getExe' pkgs.vicinae "vicinae"} server";
          Restart = "always";
          RestartSec = 5;
          KillMode = "process";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
  };
}
