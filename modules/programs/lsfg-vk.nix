{ inputs, ... }:

{
  imports = [ inputs.lsfg-vk.nixosModules.default ];

  services.lsfg-vk = {
    enable = true;
    ui.enable = true;
  };
}
