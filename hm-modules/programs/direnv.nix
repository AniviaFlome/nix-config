{
  inputs,
  ...
}:
{
  imports = [ inputs.direnv-instant.homeModules.direnv-instant ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.direnv-instant.enable = true;
}
