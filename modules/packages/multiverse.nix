{
  inputs,
  ...
}:
{
  imports = [ inputs.multiverse.nixosModules.default ];

  multiverse = {
    enable = true;
    pins = {
      opencode = "1.18.29";
    };
  };
}
