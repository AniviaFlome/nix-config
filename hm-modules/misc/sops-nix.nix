{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      generateKey = true;
    };

    secrets = {
      "github-mcp" = {
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
}
