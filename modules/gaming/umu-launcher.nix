{inputs, pkgs, ... }:

{
  environment.systemPackages = [  inputs.umu.packages.${pkgs.system}.umu  ];
}
