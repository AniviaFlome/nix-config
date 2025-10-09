{ inputs, ... }:

{
  imports = [
    inputs.xlibre-overlay.nixosModules.overlay-xlibre-xserver
    inputs.xlibre-overlay.nixosModules.overlay-all-xlibre-drivers
    inputs.xlibre-overlay.nixosModules.nvidia-ignore-ABI
  ];

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
  };
}
