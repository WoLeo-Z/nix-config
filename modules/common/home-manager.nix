# Reference: hlissner/dotfiles/modules/home.nix
# https://github.com/hlissner/dotfiles/blob/88fa021ee0d73ccbdfab9d11bbccd0dcf44a6745/modules/home.nix

# modules/home.nix -- the $HOME manager
#
# This is NOT a home-manager home.nix file. This NixOS module does two things:
#
# 1. Sets up home-manager to be used as NixOS module (exposing only a subset of
#    its API).
#
# 2. Enforce XDG compliance, whether programs want to or not.
#
# I'm sure I'm reinventing wheels by not using more of home-manager's
# capabilities, but it's already an ordeal to maintain this config on top of
# nixpkgs and its rapidly-shifting idiosynchrosies (though it's still better
# than what I had before NixOS). home-manager is one black box too many for my
# liking.

{
  lib,
  config,
  options,
  ...
}:

with builtins;
with lib;
let
  cfg = config.home';
in
{
  options.hm = mkOpt' types.attrs { } "An alias for home-manager.users.${config.user.name}";

  options.home' = with types; {
    file = mkOpt' attrs { } "Files to place directly in $HOME";
    configFile = mkOpt' attrs { } "Files to place in $XDG_CONFIG_HOME";
    dataFile = mkOpt' attrs { } "Files to place in $XDG_DATA_HOME";
    fakeFile = mkOpt' attrs { } "Files to place in $XDG_FAKE_HOME";

    dir = mkOpt str "${config.user.home}";
    binDir = mkOpt str "${cfg.dir}/.local/bin";
    cacheDir = mkOpt str "${cfg.dir}/.cache";
    configDir = mkOpt str "${cfg.dir}/.config";
    dataDir = mkOpt str "${cfg.dir}/.local/share";
    stateDir = mkOpt str "${cfg.dir}/.local/state";
    fakeDir = mkOpt str "${cfg.dir}/.local/user";
  };

  config = {
    environment.localBinInPath = true;

    environment.sessionVariables = mkOrder 10 {
      # These are the defaults, and xdg.enable does set them, but due to load
      # order, they're not set before environment.variables are set, which
      # could cause race conditions.
      XDG_BIN_HOME = cfg.binDir;
      XDG_CACHE_HOME = cfg.cacheDir;
      XDG_CONFIG_HOME = cfg.configDir;
      XDG_DATA_HOME = cfg.dataDir;
      XDG_STATE_HOME = cfg.stateDir;

      # This is not in the XDG standard. It's my jail for stubborn programs,
      # like Firefox, Steam, and LMMS.
      XDG_FAKE_HOME = cfg.fakeDir;
      XDG_DESKTOP_DIR = cfg.fakeDir;
    };

    home'.file = mapAttrs' (k: v: nameValuePair "${cfg.fakeDir}/${k}" v) cfg.fakeFile;

    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      users.${config.user.name} = mkAliasDefinitions options.hm;
    };

    hm = {
      # I only need a subset of home-manager's capabilities. That is, access to
      # its home.file, home.xdg.configFile and home.xdg.dataFile so I can deploy
      # files easily to my $HOME, but 'home-manager.users.hlissner.home.file.*'
      # is much too long and harder to maintain, so I've made aliases in:
      #
      #   home'.file        ->  home-manager.users.hlissner.home.file
      #   home'.configFile  ->  home-manager.users.hlissner.home.xdg.configFile
      #   home'.dataFile    ->  home-manager.users.hlissner.home.xdg.dataFile

      home = {
        file = mkAliasDefinitions options.home'.file;
        # Necessary for home-manager to work with flakes, otherwise it will
        # look for a nixpkgs channel.
        stateVersion = config.system.stateVersion;
      };
      xdg = {
        # enable = true;
        configFile = mkAliasDefinitions options.home'.configFile;
        dataFile = mkAliasDefinitions options.home'.dataFile;

        # Force these, since it'll be considered an abstraction leak to use
        # home-manager's API anywhere outside this module.
        cacheHome = mkForce cfg.cacheDir;
        configHome = mkForce cfg.configDir;
        dataHome = mkForce cfg.dataDir;
        stateHome = mkForce cfg.stateDir;

        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };
  };
}
