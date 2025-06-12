{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.editors.vscode;
in
{
  options.modules.desktop.apps.editors.vscode = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      programs.vscode = {
        enable = true;
        package =
          (pkgs.vscode.override {
            commandLineArgs =
              lib.constants.chromiumArgs
              # https://code.visualstudio.com/docs/editor/settings-sync#_troubleshooting-keychain-issues
              # gnome or gnome-keyring doesn't work
              ++ [ "--password-store=gnome-libsecret" ];
          }).fhs;
      };
    };
  };
}
