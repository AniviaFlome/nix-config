{
  modulesPath,
  lib,
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

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  services.openssh = {
    enable = true;
  };

  environment.systemPackages =
    with pkgs;
    map lib.lowPrio [
      curl
      gitMinimal
    ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXW5gqP/C/NQYWmWLPefoQZkZI59/O1EjptVuzvA7gA aniviaflome@gmail.com"
  ]
  ++ (args.extraPublicKeys or [ ]);

  users.users.vps = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICXW5gqP/C/NQYWmWLPefoQZkZI59/O1EjptVuzvA7gA aniviaflome@gmail.com"
    ];
  };

  system.stateVersion = "24.05";
}
