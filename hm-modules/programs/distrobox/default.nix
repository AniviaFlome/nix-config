{
  programs.distrobox = {
    enable = true;
    containers = {
      arch = {
        additional_packages = "
          atuin
          base-devel
          eza
          starship
          bat
        ";
        entry = true;
        image = "quay.io/toolbx/arch-toolbox:latest";
        nvidia = true;
        exported_apps = "

        ";
        exported_bins = "

        ";
      };
    };
    settings = {
      container_manager = "podman";
    };
  };
}
