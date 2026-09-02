{
  inputs,
  pkgs,
  username,
  ...
}:
{
  imports = [ inputs.waydroid-nvidia-nix.nixosModules.waydroid-nvidia ];

  services.waydroid-nvidia = {
    enable = true;
    refreshRate = 144;
    package = pkgs.waydroid-nvidia-full;
  };

  virtualisation.lxc.enable = true;

  networking.firewall.trustedInterfaces = [ "waydroid0" ];

  systemd.tmpfiles.rules = [
    "d /var/lib/misc 0755 root root -"
  ];

  # Unit is installed system-wide; without this, SDDM's greeter session also
  # starts it and grabs /run/waydroid-venus/venus.sock as the sddm user,
  # leaving a stale socket your session can't remove (sticky-bit dir).
  systemd.user.services.wd-venus.unitConfig.ConditionUser = username;

  services.dbus.packages = [
    pkgs.waydroid-nvidia-full
  ];

  environment.systemPackages = with pkgs; [
    waydroid-helper
  ];
}
