{
  lib,
  config,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.develop.flutter;
in
{
  options.modules.desktop.develop.flutter = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      home.packages = with pkgs; [
        flutter

        mesa-demos # provides eglinfo for "flutter doctor"

        # We need to install Android SDK & cmdline-tools in Android Studio manually.
        (android-studio.override {
          # Fix Wayland HiDPI, scaling too large
          # https://wiki.archlinux.org/title/HiDPI#JetBrains_IDEs
          forceWayland = true;
        })
      ];

      programs.vscode = {
        profiles.default = {
          userSettings = {
            # Recommended Settings for VS Code
            # https://dartcode.org/docs/recommended-settings/

            "debug.internalConsoleOptions" = "openOnSessionStart";
            "[dart]" = {
              "editor.formatOnSave" = true;
              "editor.formatOnType" = true;
              "editor.rulers" = [ 80 ];
              "editor.selectionHighlight" = false;
              "editor.tabCompletion" = "onlySnippets";
              "editor.wordBasedSuggestions" = "off";
            };
          };
          extensions = with pkgs.vscode-extensions; [
            dart-code.flutter
            dart-code.dart-code
          ];
        };
      };
    };

    environment.sessionVariables = mkIf config.modules.desktop.apps.browsers.google-chrome.enable {
      CHROME_EXECUTABLE = "${lib.getExe pkgs.google-chrome}";
    };

    nixpkgs.config.android_sdk.accept_license = true;

    programs.adb.enable = true;
    user.extraGroups = [ "adbusers" ];
  };
}
