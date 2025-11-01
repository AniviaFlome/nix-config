{
  term-editor,
  ...
}:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "aniviaflome@gmail.com";
        name = "AniviaFlome";
      };
      color.ui = true;
      core.editor = term-editor;
      init.defaultBranch = "main";
    };
  };
}
