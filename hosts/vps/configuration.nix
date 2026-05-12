{
  modulesPath,
  pkgs,
  ...
}@args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    ./imports.nix
  ];

  boot = {
    supportedFilesystems = [ "ext4" ];
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  services.openssh = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    micro-full
  ];

  users.users = {
    vps = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      initialPassword = "1234";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXW5gqP/C/NQYWmWLPefoQZkZI59/O1EjptVuzvA7gA aniviaflome@gmail.com"
      ]
      ++ (args.extraPublicKeys or [ ]);
    };
    root = {
      initialPassword = "1234";
    };
  };

  system.stateVersion = "24.05";
}
