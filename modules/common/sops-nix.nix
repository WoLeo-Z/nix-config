{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  environment.variables = {
    # this file is placed manually on new installs
    SOPS_AGE_KEY_FILE = "/var/lib/sops-nix/key.txt";
  };

  sops = {
    defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age = {
      # This will automatically import SSH keys as age keys
      # sshKeyPaths = [
      #   "/etc/ssh/ssh_host_ed25519_key"
      #   "${config.user.home}/.ssh/id_ed25519"
      # ];
      sshKeyPaths = [ ];
      # This is using an age key that is expected to already be in the filesystem
      keyFile = config.environment.variables.SOPS_AGE_KEY_FILE;
      # This will generate a new key if the key specified above does not exist
      generateKey = false;
    };
  };

  # the same key file as "/var/lib/sops-nix/key.txt"
  # for editing secrets with user permission only
  sops.secrets."sops-age-key-file" = {
    sopsFile = "${inputs.nix-secrets}/secrets.yaml";
    key = "sops-age-key-file"; # Specify the location of this secret
    mode = "0600";
    owner = config.user.name;
  };
  hm.xdg.configFile."sops/age/keys.txt".source =
    lib.mkOutOfStoreSymlink
      config.sops.secrets."sops-age-key-file".path;
}
