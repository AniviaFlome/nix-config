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
    ./imports.nix
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    loader.grub = {
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  networking.hostId = "3b8c3b1e";

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
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
    };
    root = {
      initialPassword = 1234;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXW5gqP/C/NQYWmWLPefoQZkZI59/O1EjptVuzvA7gA aniviaflome@gmail.com"
      ]
      ++ (args.extraPublicKeys or [ ]);
    };
  };

  system.stateVersion = "24.05";
}
