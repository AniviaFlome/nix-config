{
  inputs,
  ...
}:
{
  imports = [ inputs.cachy-tweaks.nixosModules.default ];

  cachy = {
    enable = true;
    all = false;

    ananicy = false;
    audio = true;
    kernel = true;
    modprobe = true;
    scripts = true;
    systemd = true;
    udev = true;
    wireless = true;
    xserver = true;
  };
}
