{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.services.mihomo;
in
{
  options.modules.services.mihomo = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    services.mihomo = {
      enable = true;
      package = pkgs.mihomo;
      tunMode = true;
      # webui = pkgs.zashboard;
      configFile = "${config.home'.configDir}/mihomo/config.yaml";
    };

    systemd.services.mihomo.serviceConfig = {
      Restart = "on-failure";
    };

    # services.lighttpd = {
    #   enable = true;
    #   port = 80;
    #   document-root = "${pkgs.zashboard}";
    #   extraConfig = ''server.bind = "127.0.0.88"'';
    # };

    # networking.hosts = {
    #   # "127.0.0.64" = [ "mihomo.local" ]; # Mihomo
    #   "127.0.0.88" = [ "dash.local" ]; # Dashboard
    # };

    networking.proxy = {
      default = lib.mkDefault "http://127.0.0.1:7890";
      noProxy = lib.mkDefault "127.0.0.1,::1,localhost,.localdomain";
    };

    # # Encrypt whole yaml (binary format):
    # # sops encrypt /home/wol/.config/mihomo/config.yaml --input-type binary | save mihomo_config.yaml
    # sops.secrets.mihomo-config = {
    #   sopsFile = "${inputs.nix-secrets}/mihomo_config.yaml";
    #   key = "data";
    # };
  };
}
