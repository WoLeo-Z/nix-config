{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;

  environment.shellInit = ''
    ${lib.getExe' pkgs.openssh "ssh-add"}
  '';

  hm = {
    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = {
        "github.com" = {
          # "Using SSH over the HTTPS port for GitHub"
          # "(port 22 is banned by some proxies / firewalls)"
          hostname = "ssh.github.com";
          port = 443;
          user = "git";

          # Specifies that ssh should only use the identity file explicitly configured above
          # required to prevent sending default identity files first.
          identitiesOnly = true;
        };
      };
    };
  };

  sops.secrets."private_keys/users/wol" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "users/wol"; # Specify the location of this secret
  };
}
