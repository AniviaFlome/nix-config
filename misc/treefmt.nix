{
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    deadnix.enable = true;
    statix.enable = true;
    shfmt.enable = true;
    prettier.enable = true;
  };

  settings = {
    walk = "filesystem";
    global.excludes = [
      "LICENSE"
      "*.{gif,png,svg,tape,mts,lock,mod,sum,env,envrc,gitignore,pages}"
    ];
    formatter = {
      prettier = {
        options = [
          "--tab-width"
          "2"
        ];
        includes = [ "*.{css,html,js,json,jsx,md,mdx,scss,ts,yaml}" ];
      };
    };
  };
}
