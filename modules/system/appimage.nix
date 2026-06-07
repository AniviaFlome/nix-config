{
  flake.modules.nixos.appimage = {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
