{ pkgs, inputs, config, ... }:

{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../.././secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      ssh-key = {};
      syncthing = {};
    };

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key"];
      keyFile = "/home/user/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  environment.systemPackages = with pkgs; [ sops ];
}
