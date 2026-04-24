{
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        nixfmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        shfmt.enable = true;
      };

      settings = {
        walk = "filesystem";
        global.excludes = [
          "LICENSE"
          "*.{gif,png,svg,tape,mts,lock,mod,sum,env,envrc,gitignore,pages}"
        ];
      };
    };
  };
}
