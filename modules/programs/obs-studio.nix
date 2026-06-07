{
  flake.modules.nixos.obs-studio = {
    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
    };
  };

  flake.modules.homeManager.obs-studio =
    { pkgs, ... }:
    {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          droidcam-obs
          obs-vkcapture
          wlrobs
        ];
      };
    };
}
