{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.niri.nixosModules.niri ];

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  environment.systemPackages = with pkgs; [
    nautilus
    xwayland-satellite
  ];

  systemd.user.services.niri-flake-polkit.enable = false;

  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".text =
    lib.mkIf config.hardware.nvidia.enabled
      (
        builtins.toJSON {
          rules = [
            {
              pattern = {
                feature = "procname";
                matches = "niri";
              };
              profile = "Limit Free Buffer Pool On Wayland Compositors";
            }
          ];
          profiles = [
            {
              name = "Limit Free Buffer Pool On Wayland Compositors";
              settings = [
                {
                  key = "GLVidHeapReuseRatio";
                  value = 0;
                }
              ];
            }
          ];
        }
      );
}
