{
  config,
  pkgs,
  term-editor,
  username,
  ...
}:
{
  home.packages = with pkgs; [ git-absorb ];

  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.git = {
    enable = true;
    signing.format = "openpgp";
    settings = {
      user = {
        email = config.sops.secrets."mail".path;
        name = username;
      };
      color.ui = true;
      core.editor = term-editor;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    ignores = [
      ".DS_Store"
      ".env"
      "Thumbs.db"
    ];
  };
}
