{
  inputs,
  osConfig,
  ...
}:
{
  imports = [ inputs.distrobox-flake.homeManagerModules.default ];

  programs.distrobox = {
    enable = true;
    enableSystemdUnit = true;
    settings = {
      container_manager = "podman";
    };
    containers = {
      arch = {
        image = "quay.io/toolbx/arch-toolbox:latest";
        nvidia = osConfig.hardware.nvidia-containers.enable;
        pull = true;
        replace = true;
        additional_packages = builtins.concatStringsSep " " [
          "atuin"
          "base-devel"
          "bat"
          "eza"
          "fastfetch"
          "starship"
        ];
      };
      fedora = {
        image = "quay.io/fedora/fedora-toolbox:rawhide";
        nvidia = osConfig.hardware.nvidia-containers.enable;
        pull = true;
        replace = true;
        additional_packages = builtins.concatStringsSep " " [

        ];
      };
    };
  };

  programs.distrobox-flake = {
    enable = true;
    containers = {
      arch = {
        alias = {
          enable = true;
        };
        aur = {
          enable = true;
          packages = [

          ];
        };
      };
      fedora = {
        alias = {
          enable = true;
        };
        copr = {
          enable = true;
          repos = [
            "atim/starship"
          ];
          packages = [
            "starship"
          ];
        };
        rpmfusion = {
          free.enable = true;
          unfree.enable = true;
        };
      };
    };
  };
}
