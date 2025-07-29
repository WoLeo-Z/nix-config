{
  lib,
  config,
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
        # inputs.zen-browser.homeModules.beta
        inputs.zen-browser.homeModules.twilight
        # inputs.zen-browser.homeModules.twilight-official
      ];

      programs.zen-browser = {
        enable = true;
        policies = {
          AutofillAddressesEnabled = false;
          AutoFillCreditCardEnabled = false;
          DisableAppUpdate = true;
          DisablePocket = true;
          DisableSetDesktopBackground = true;
          DisableTelemetry = true;
          DontCheckDefaultBrowser = true;
          FirefoxHome = {
            Search = true;
            TopSites = false;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            Locked = true;
          };
          Homepage = {
            URL = "about:home";
            Locked = true;
            StartPage = "homepage";
          };
          NoDefaultBookmarks = true;
          PasswordManagerEnabled = false;
          SearchBar = "unified";
          SearchSuggestEnabled = true;
          ShowHomeButton = false;
        };
      };
    };
  };
}
