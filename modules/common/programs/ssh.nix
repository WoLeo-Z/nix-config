{
  pkgs,
  lib,
  inputs,
  config,
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
        "do-sfo" = {
          hostname = "do-sfo";
          port = 22;
          user = "root";
          identityFile = config.sops.secrets."private_keys/hosts/do-sfo".path;
        };
        "ah-us" = {
          hostname = "ah-us";
          port = 22;
          user = "root";
          identityFile = config.sops.secrets."private_keys/hosts/ah-us".path;
        };
      };
    };
  };

  sops.secrets."private_keys/hosts/do-sfo" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/do-sfo"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
  sops.secrets."private_keys/hosts/ah-us" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/ah-us"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
}
