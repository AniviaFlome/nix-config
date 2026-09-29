{
  programs.herdr = {
    enable = true;
    settings = {
      onboarding = false;
      theme = {
        auto_switch = true;
        dark_name = "catppuccin";
        light_name = "catppuccin-latte";
        name = "catppuccin";
      };
      ui = {
        agent_panel_sort = "priority";
        sidebar_width = 32;
        sound = {
          enabled = true;
        };
        toast = {
          delivery = "herdr";
        };
      };
      update.version_check = false;
    };
  };
}
