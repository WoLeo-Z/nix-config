# Reference: hlissner/dotfiles/default.nix
# https://github.com/hlissner/dotfiles/blob/88fa021ee0d73ccbdfab9d11bbccd0dcf44a6745/default.nix

{ lib, options, config, ... }:

with lib;
{
  options = with types; {
    modules = {};

    # Creates a simpler, polymorphic alias for users.users.$USER.
    user = mkOpt attrs { name = ""; };
  };

  config = {
    environment.sessionVariables = mkOrder 10 {
      # DOTFILES_HOME = config.dir; # TODO
      NIXPKGS_ALLOW_UNFREE = "1";   # Forgive me Stallman-senpai.
    };

    # FIXME: Make this optional
    user = {
      description = mkDefault "The primary user account";
      extraGroups = [ "wheel" ];
      isNormalUser = true;
      home = "/home/${config.user.name}";
      group = "users";
      uid = 1000;
    };
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    # fileSystems."/".device = mkDefault "/dev/disk/by-label/nixos";
  };
}
