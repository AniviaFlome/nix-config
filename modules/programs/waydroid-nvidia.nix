{
  inputs,
  pkgs,
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

  systemd.user.services.wd-venus.serviceConfig.ExecStartPre = [
    "-/run/current-system/sw/bin/rm -f /run/waydroid-venus/venus.sock"
  ];

  services.dbus.packages = [
    pkgs.waydroid-nvidia-full
  ];

  environment.systemPackages = with pkgs; [
    waydroid-helper
  ];
}
