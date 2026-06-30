{
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-cli.nixosModules.nixos-cli ];

  programs.nixos-cli = {
    enable = true;
  };
}
