{
  programs.distrobox = {
    enable = true;
    settings = {
      container_manager = "podman";
    };
    containers = {
      arch = {
        image = "ghcr.io/greyltc-org/archlinux-aur:paru";
        nvidia = true;
        pull = true;
        replace = true;
        additional_packages = "
          atuin
          base-devel
          bat
          eza
          fastfetch
          starship
        ";
        init_hooks = "
          paru -S --needed --noconfirm \
          helium-browser-bin \
          torrra
        ";
        exported_apps = "
          helium-browser
        ";
        exported_bins = "
          helium-browser
          torrra
        ";
      };
    };
  };
}
