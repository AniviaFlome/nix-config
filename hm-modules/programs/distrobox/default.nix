{
  inputs,
  osConfig,
  pkgs,
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
        nvidia = osConfig.hardware.nvidia-containers.enable or false;
        pull = true;
        replace = true;
        additional_packages = builtins.concatStringsSep " " [

        ];
      };
      fedora = {
        image = "quay.io/fedora/fedora-toolbox:rawhide";
        nvidia = osConfig.hardware.nvidia-containers.enable or false;
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
        alias.enable = true;
        packages = with pkgs; [
          atuin
          bat
          eza
          fastfetch
          starship
        ];
        aur = {
          enable = true;
          packages = [

          ];
        };
      };
      fedora = {
        alias.enable = true;
        packages = with pkgs; [
          atuin
          bat
          eza
          fastfetch
          starship
        ];
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
          free = {
            enable = true;
            packages = [

            ];
          };
          unfree = {
            enable = true;
            packages = [

            ];
          };
        };
      };
    };
  };
}
