{ inputs, ... }:
{
  flake.modules.nixos.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
      programs.niri = {
        enable = true;
        package = pkgs.niri;
      };
      environment.systemPackages = with pkgs; [
        nautilus
        xwayland-satellite
      ];
      systemd.user.services.niri-flake-polkit.enable = false;
      environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool.json".text =
        lib.mkIf config.hardware.nvidia.enabled
          (
            {
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
            |> builtins.toJSON
          );
    };

  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      imports = [
        ./keybinds.nix
        ./settings.nix
        ./autostart.nix
      ];

      home.packages = with pkgs; [
        nirius
        xwayland-satellite
        kdePackages.breeze
        kdePackages.qqc2-breeze-style
      ];
    };
}
