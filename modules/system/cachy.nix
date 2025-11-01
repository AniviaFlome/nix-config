{ inputs, ... }:
{
  imports = [ inputs.cachy-tweaks.nixosModules.default ];

  cachy = {
    enable = true;
    all = false;
    kernel = true;
    modprobe = true;
    scripts = true;
    systemd = true;
    udev = true;
    xserver = true;
    zram = false;
  };
}
