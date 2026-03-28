{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.apps.browsers.zen-browser;
in
{
  options.modules.desktop.apps.browsers.zen-browser = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm = {
      imports = [
        inputs.zen-browser.homeModules.beta
        # inputs.zen-browser.homeModules.twilight
        # inputs.zen-browser.homeModules.twilight-official
      ];

      programs.zen-browser = {
        enable = true;
        # profiles.default.settings = { };
      };

      xdg.mimeApps = {
        defaultApplications =
          let
            apply = app: mimes: lib.genAttrs mimes (_: app);
          in
          (apply "zen-beta.desktop" [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]);
      };
    };
  };
}
