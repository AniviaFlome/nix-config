{ inputs, ... }:

{
  imports = [ inputs.plasma-manager.homeModules.plasma-manager ];

  programs.kate = {
    enable = true;
    editor = {
      brackets = {
        automaticallyAddClosing = true;
        highlightMatching = true;
      };
      font = {
        family = "$IDE_FONT}";
        pointSize = 12;
      };
    };
  };
}
