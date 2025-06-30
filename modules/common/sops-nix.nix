{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  sops = {
    defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age = {
      # This will automatically import SSH keys as age keys
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "${config.user.home}/.ssh/id_ed25519"
      ];
      # This is using an age key that is expected to already be in the filesystem
      # keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      # generateKey = false;
    };
  };

  # SSH Key Preparation
  # When you run "sops [file]", you may get "age: no identity matched any of the recipients"
  # Solotion:
  #
  # mkdir ~/.config/sops/age
  # nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
  # chmod 600 ~/.config/sops/age/keys.txt
}
