{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  hm = {
    imports = [ inputs.sops-nix.homeManagerModules.sops ];
  };

  environment.systemPackages = with pkgs; [
    age
    sops
  ];

  sops = {
    # defaultSopsFile = "${inputs.nix-secrets}/secrets.yaml";
    age = {
      sshKeyPaths = [
        "/etc/ssh/ssh_host_ed25519_key"
        "${config.user.home}/.ssh/id_ed25519"
      ];
    };
  };
}
