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
        package = pkgs.vscode.override {
          commandLineArgs =
            lib.constants.chromiumArgs
            # https://code.visualstudio.com/docs/editor/settings-sync#_troubleshooting-keychain-issues
            # gnome or gnome-keyring doesn't work
            ++ [ "--password-store=gnome-libsecret" ];
        };
        profiles.default = {
          userSettings = {
            # Text Editor
            "editor.smoothScrolling" = true;
            "editor.tabSize" = 2;
            "editor.cursorSmoothCaretAnimation" = "on";
            "editor.formatOnPaste" = true;
            "editor.formatOnSave" = true;
            "diffEditor.experimental.showMoves" = true;
            "files.autoSave" = "onFocusChange";
            "files.readonlyFromPermissions" = true;

            # Workbench
            "workbench.editor.empty.hint" = "hidden";
            "workbench.startupEditor" = "none";

            # Window
            "window.controlsStyle" = "hidden";

            # Features
            "explorer.confirmDelete" = false;
            "extensions.ignoreRecommendations" = true;

            # Application
            "telemetry.telemetryLevel" = "off";

            # Extensions

            # Git
            "git.allowForcePush" = true;
            "git.autofetch" = true;

            # GitHub
            "github.gitProtocol" = "ssh";

            # Nix
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "${lib.getExe pkgs.nixd}";
            "nix.serverSettings" = {
              # check https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md for all nixd config
              "nixd" = {
                "formatting" = {
                  "command" = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
                  arguments = [ "--strict" ];
                };
              };
            };
            "nix.hiddenLanguageServerErrors" = [
              # Fix: https://github.com/nix-community/vscode-nix-ide/issues/482
              "textDocument/definition"
            ];
          };
          extensions = with pkgs.vscode-extensions; [
            ms-ceintl.vscode-language-pack-zh-hans
            jnoortheen.nix-ide
            gruntfuggly.todo-tree
          ];
        };
      };

      stylix.targets.vscode.enable = true;
    };
  };
}
