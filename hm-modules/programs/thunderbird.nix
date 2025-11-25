{
  programs.thunderbird = {
    enable = true;
    settings = {
      "privacy.donottrackheader.enabled" = false;
      "privacy.globalprivacycontrol.enabled" = true;
    };
    profiles."main" = {
      isDefault = true;
      accountsOrder = [
        "gmail"
      ];
      search = {
        default = "ddg";
        privateDefault = "ddg";
        force = true;
      };
    };
  };
}
