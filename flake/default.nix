{
  imports = [
    ./variables.nix
    ./lib.nix
    ./formatter.nix
    ./shell.nix
    ../hosts/nixos/flake.nix
    ../hosts/vps/flake.nix
    ../hosts/liveiso/flake.nix
    ../hosts/liveiso-minimal/flake.nix
  ];
}
