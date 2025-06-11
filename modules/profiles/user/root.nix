{ config, inputs, ... }:

{
  config = {
    sops.secrets."passwords/users/root" = {
      sopsFile = "${inputs.nix-secrets}/secrets.yaml";
      # key = "passwords/users/root"; # Specify the location of this secret
      neededForUsers = true;
    };

    users.users.root = {
      hashedPasswordFile = config.sops.secrets."passwords/users/root".path;
    };
  };
}
