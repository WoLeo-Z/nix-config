# Reference: hlissner/dotfiles/modules/profiles/user/hlissner.nix
# https://github.com/hlissner/dotfiles/blob/88fa021ee0d73ccbdfab9d11bbccd0dcf44a6745/modules/profiles/user/hlissner.nix

{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

with lib;
let
  cfg = config.modules.profiles;
in
mkIf (cfg.user == "wol") (mkMerge [
  {
    user.name = "wol";
    user.description = "WoL";
    i18n.defaultLocale = "zh_CN.UTF-8";
    user.shell = pkgs.nushell;

    sops.secrets."passwords/users/wol" = {
      sopsFile = "${inputs.nix-secrets}/secrets.yaml";
      # key = "passwords/users/wol"; # Specify the location of this secret
      neededForUsers = true;
    };
    user.hashedPasswordFile = config.sops.secrets."passwords/users/wol".path;

    user.openssh.authorizedKeys.keys = [ lib.constants.users.wol.publicKey ];

    # modules.shell.vaultwarden.settings.server = "vault.home.lissner.net";

    # Be slightly more restrictive about SSH access to workstations, which I
    # only need LAN access to, if ever. Other systems, particularly servers, are
    # remoted into often, so I leave their access control to an upstream router
    # or local firewall.
    # user.openssh.authorizedKeys.keys = [
    #   (if role == "workstation"
    #    then ''from="10.0.0.0/8" ${key} ${username}''
    #    else key)
    # ];

    # Allow key-based root access only from private ranges.
    # users.users.root.openssh.authorizedKeys.keys = [
    #   ''from="10.0.0.0/8" ${key} ${username}''
    # ];
  }
])
