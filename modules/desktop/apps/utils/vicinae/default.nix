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
    user.packages = with pkgs; [ vicinae ];

    hm = {
      xdg.configFile."vicinae" = {
        source = ./config;
        recursive = true;
      };

      # We don't use systemd service to start the server
      # because we want to start it in the window manager
      # so that vicinae server can have correct environment variables
      #
      # https://github.com/nix-community/home-manager/blob/13cc1efd78b943b98c08d74c9060a5b59bf86921/modules/programs/vicinae.nix#L245-L265
    };

    # systemd.user.services.vicinae = {
    #   wantedBy = [ "graphical-session.target" ];
    #   unitConfig = {
    #     Description = "Vicinae server daemon";
    #     Documentation = [ "https://docs.vicinae.com" ];
    #     After = [ "graphical-session.target" ];
    #     PartOf = [ "graphical-session.target" ];
    #   };
    #   serviceConfig = {
    #     EnvironmentFile = pkgs.writeText "vicinae-env" ''
    #       USE_LAYER_SHELL=1
    #     '';
    #     Type = "simple";
    #     ExecStart = "${lib.getExe' pkgs.vicinae "vicinae"} server";
    #     Restart = "always";
    #     RestartSec = 5;
    #     KillMode = "process";
    #   };
    # };
  };
}
