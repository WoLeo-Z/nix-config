{ pkgs, config, ... }:

{
  hm = {
    programs.yazi = {
      enable = true;
      extraPackages = with pkgs; [
        imagemagick # mediainfo
        mediainfo # mediainfo
        (ouch.override {
          # RAR code is under non-free unRAR license
          enableUnfree = config.nixpkgs.config.allowUnfree;
        }) # ouch
        trash-cli # restore
      ];
      shellWrapperName = "y";

      plugins = {
        inherit (pkgs.yaziPlugins)
          chmod
          diff
          full-border
          git
          mediainfo
          mount
          ouch
          restore
          smart-filter
          sudo
          toggle-pane
          wl-clipboard
          yatline
          ;
      };
    };

    xdg.configFile = {
      "yazi/init.lua" = {
        source = pkgs.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/common/programs/yazi/config/init.lua";
      };
      "yazi/keymap.toml" = {
        source = pkgs.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/common/programs/yazi/config/keymap.toml";
      };
      "yazi/yazi.toml" = {
        source = pkgs.mkOutOfStoreSymlink "${config.programs.nh.flake}/modules/common/programs/yazi/config/yazi.toml";
      };
    };

    stylix.targets.yazi.enable = true;
  };
}
