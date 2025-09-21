{ inputs, ide-font, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.kate = {
    enable = true;
    editor = {
      brackets= {
        automaticallyAddClosing = false;
        highlightMatching = false;
      };
      font = {
        family = "${ide-font}";
        pointSize = 12;
      };
    };
  };
}
