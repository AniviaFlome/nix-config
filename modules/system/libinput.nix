{
  services.libinput = {
    enable = true;
    mouse = {
      accelProfile = "flat";
      additionalOptions = ''
        [Never Debounce]
        MatchUdevType=mouse
        ModelBouncingKeys=1
      '';
    };
  };
}
