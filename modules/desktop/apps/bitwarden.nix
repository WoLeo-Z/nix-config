{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.bitwarden;
in
{
  options.modules.desktop.apps.bitwarden = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [ bitwarden-desktop ];
      home.sessionVariables = {
        # SSH_AUTH_SOCK = "${config.user.home}/.bitwarden-ssh-agent.sock";
      };
    };
  };
}
