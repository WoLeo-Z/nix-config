{ lib, config, ... }:

with lib;
let
  cfg = config.modules.desktop.apps.browsers.firefox;
in
{
  options.modules.desktop.apps.browsers.firefox = {
    enable = mkEnableOption' { };
  };

  config = mkIf cfg.enable {
    hm.programs.firefox = {
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
}
