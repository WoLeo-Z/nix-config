{ lib, config, pkgs, ... }:

with lib;
let cfg = config.modules.desktop.terminal.foot;
in {
  options.modules.desktop.terminal.foot = {
    enable = mkEnableOption "Enable foot terminal emulator";
  };

  config = mkIf cfg.enable {
    home-manager.users.wol.home.packages = with pkgs; [
      foot
      libsixel # image support in foot
    ];

    # TODO: Add foot config or use home.configFile
  };
}
