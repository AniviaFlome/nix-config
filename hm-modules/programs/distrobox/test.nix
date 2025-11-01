{
  inputs,
  ...
}:
{
  imports = [ inputs.distrobox.homeManagerModules.default ];

  programs.distrobox = {
    enable = true;
    containers = {
      arch-dev = {
        distro = "arch";
        image = "quay.io/toolbx/arch-toolbox:latest";
        packages = [
          "base-devel"
          "git"
          "neovim"
          "python"
          "nodejs"
        ];
        aurPackages = [
          "paru-bin"
          "visual-studio-code-bin"
          "spotify"
        ];
        autoUpdate = true;
      };
      fedora-dev = {
        distro = "fedora";
        image = "quay.io/fedora/fedora-toolbox:rawhide";
        packages = [
          "gcc"
          "make"
          "cmake"
          "starship"
        ];
        coprRepos = [ "atim/starship" ];
        autoUpdate = true;
      };
    };
  };
}
