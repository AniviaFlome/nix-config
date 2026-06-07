{ inputs, self, ... }:
{
  flake.modules.nixos.sops =
    { pkgs, config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";

        age = {
          sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
          keyFile = "/var/lib/sops-nix/keys.txt";
          generateKey = true;
        };

        secrets = {
          "syncthing-password" = {
            mode = "0400";
            owner = config.services.syncthing.user;
          };
          "nix-access-token" = {
            mode = "0400";
          };
          "vps-password" = {
            mode = "0400";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        age
        sops
      ];
    };

  flake.modules.homeManager.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";

        age = {
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          generateKey = true;
        };

        secrets = {
          "github-mcp" = {
            mode = "0400";
          };
          "listenbrainz-token" = {
            mode = "0400";
          };
          "mail" = {
            mode = "0400";
          };
          "nix-access-token" = {
            mode = "0400";
          };
        };
      };
    };
}
