{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.restic;
in
{
  options.modules.services.restic = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      restic
      rclone
    ];

    services.restic.backups = {
      obsidian = {
        paths = [
          "/home/wol/Documents"
          "/home/wol/Pictures"
        ];
        repository = "rclone:pan-moe-backup:obsidian";

        timerConfig = {
          OnCalendar = "*-*-* 08:00:00";
          Persistent = true;
        };
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 5"
        ];
        passwordFile = config.sops.secrets."restic/obsidian".path;
      };
    };

    sops.secrets."restic/obsidian" = {
      key = "restic/obsidian";
    };

    # TODO: Add encrypted rclone config in nix-secrets

    # xdg.configFile."rclone/rclone.conf" = {
    #   source = config.sops.secrets."rclone/conf".path;
    # };

    # sops.secrets."rclone/conf" = {
    #   key = "rclone/conf";
    # };
  };
}
