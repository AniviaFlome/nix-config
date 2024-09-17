{
  # Enable networking
  networking = {
    networkmanager.enable = true;
    nameservers = ["9.9.9.9"];
  };

  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "true";
  };
}
