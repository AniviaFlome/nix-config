{
  inputs,
  ...
}:
{
  imports = [ inputs.multiverse.nixosModules.default ];

  multiverse = {
    enable = true;
    pins = {
      glib = "2.86.3";
    };
  };
}
