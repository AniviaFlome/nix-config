{ inputs, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXPKGS_ALLOW_UNFREE = "1";
    MANUAL = "nvim";
#     _JAVA_OPTIONS= "-Dawt.useSystemAAFontSettings=lcd";
  };
}
