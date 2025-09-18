{ pkgs, inputs, config, username, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      "syncthing-password" = { };
      "nix-access-token-github" = { };
    };
  };

  environment.systemPackages = with pkgs; [ sops ];
}
