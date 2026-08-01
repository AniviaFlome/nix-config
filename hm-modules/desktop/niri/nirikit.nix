{
  inputs,
  ...
}:
{
  imports = [ inputs.nirikit.homeModules.default ];

  programs.nirikit = {
    enable = true;
  };
}
