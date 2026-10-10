{
  inputs,
  ...
}:
{
  imports = [ inputs.nixdatifier.homeManagerModules.default ];

  programs.nixdatifier = {
    enable = true;
    autostart = false;
  };
}
