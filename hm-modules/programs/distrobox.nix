{
  programs.distrobox = {
    enable = true;
    containers = {
      arch = {
        additional_packages = "
          atuin
          base-devel
          bat
          eza
          fastfetch
          starship
        ";
        image = "ghcr.io/greyltc-org/archlinux-aur:paru";
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
