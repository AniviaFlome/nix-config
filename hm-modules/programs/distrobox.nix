{
  inputs,
  ...
}:
{
  imports = [ inputs.distrobox.homeManagerModules.default ];

  programs.distrobox-flake = {
    enable = true;
    containers = {
      arch = {
        distro = "arch";
        image = "quay.io/toolbx/arch-toolbox:latest";
        packages = [
          "atuin"
          "bat"
          "eza"
          "fastfetch"
          "starship"
        ];
        aurPackages = [
          "windsurf"
        ];
      };
      fedora = {
        distro = "fedora";
        image = "quay.io/fedora/fedora-toolbox:rawhide";
        packages = [
          "atuin"
          "bat"
          "fastfetch"
          "starship"
        ];
        coprRepos = [
          "atim/starship"
        ];
      };
      ubuntu = {
        distro = "debian";
        image = "quay.io/toolbx/ubuntu-toolbox:latest";
        packages = [
          "bat"
          "neofetch"
        ];
      };
    };
  };
}
