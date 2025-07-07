{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.steam;
in
{
  options.modules.desktop.apps.steam = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        # extraCompatPackages = [ pkgs.proton-ge-bin ];
        gamescopeSession.enable = true;
      };

      gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 15;
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [ mangohud ];

    hm.xdg.desktopEntries.steam-gamescope = {
      name = "Steam Gamescope";
      exec = "gamemoderun gamescope -W 1920 -H 1080 -w 1920 -h 1080 -f -e -- steam -gamepadui";
      icon = "steam";
      terminal = false;
      type = "Application";
      categories = [ "Game" ];
      # startupNotify = true;
    };

    # Better for steam proton games
    systemd.extraConfig = "DefaultLimitNOFILE=1048576";

    # Support Xbox wireless controllers
    hardware.xpadneo.enable = true;
  };
}
