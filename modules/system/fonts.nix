{
  pkgs,
  ...
}:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.caskaydia-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.noto
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
        ];
      };
    };
  };
}
