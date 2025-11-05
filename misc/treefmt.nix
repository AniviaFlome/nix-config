{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    prettier.enable = true;
    shfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
  };
}
