{
  flake.modules.nixos.fonts =
    { pkgs, font, ... }:
    {
      fonts = {
        enableDefaultPackages = true;
        packages = with pkgs; [
          nerd-fonts.caskaydia-mono
          nerd-fonts.fira-code
          nerd-fonts.hack
          nerd-fonts.jetbrains-mono
          nerd-fonts.noto
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
        ];
        fontconfig.defaultFonts.sansSerif = [ font ];
      };
    };
}
