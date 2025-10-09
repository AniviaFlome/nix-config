{ pkgs, inputs, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/keys.txt";
      generateKey = true;
    };

    secrets = {
      "syncthing-password" = { 
        mode = "0400";
      };
      "nix-access-token" = {
        mode = "0400";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
