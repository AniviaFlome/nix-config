{
  pkgs,
  ...
}:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      fontconfig
      freetype
      SDL2
      SDL2_image
      SDL2_mixer
      SDL2_ttf

      stdenv.cc.cc
      zlib
      zstd
      bzip2
      xz
      libgcc
      openssl
      curl

      # Graphics / windowing
      libglvnd
      mesa
      vulkan-loader
      sdl3
      sdl2-compat

      libX11
      libXext
      libXrender
      libXfixes
      libXcursor
      libXi
      libXrandr
      libXinerama
      libXdamage
      libXcomposite
      libxcb
      libXau
      libXdmcp

      wayland
      libxkbcommon

      # Audio
      alsa-lib
      pulseaudio

      # Odds and ends often needed
      glib
      gtk3
      nss
      nspr
      dbus
      expat
      libdrm
      udev
    ];
  };
}
