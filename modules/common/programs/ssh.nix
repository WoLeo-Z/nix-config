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
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
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

        # my servers
        "do-sgp" = {
          hostname = "do-sgp";
          port = 10022;
          user = "root";
          identityFile = config.sops.secrets."private_keys/hosts/do-sgp".path;
        };
        "ah-us" = {
          hostname = "ah-us";
          port = 10022;
          user = "root";
          identityFile = config.sops.secrets."private_keys/hosts/ah-us".path;
        };
        "alice-hk" = {
          hostname = "alice-hk";
          port = 10022;
          user = "root";
          identityFile = config.sops.secrets."private_keys/hosts/alice-hk".path;
        };
        "azure-jp1" = {
          hostname = "azure-jp1";
          port = 10022;
          user = "wol";
          identityFile = config.sops.secrets."private_keys/hosts/azure-jp1".path;
        };
      };
    };
  };

  sops.secrets."private_keys/hosts/do-sgp" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/do-sgp"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
  sops.secrets."private_keys/hosts/ah-us" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/ah-us"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
  sops.secrets."private_keys/hosts/alice-hk" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/alice-hk"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
  sops.secrets."private_keys/hosts/azure-jp1" = {
    sopsFile = "${inputs.nix-secrets}/private_keys.yaml";
    key = "hosts/azure-jp1"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
}
