{ pkgs, ... }:

{
  fonts.packages = with pkgs; [
cascadia-code
fira-code
fira-code-symbols
jetbrains-mono
noto-fonts
noto-fonts-cjk-sans
noto-fonts-emoji
  ];
}
