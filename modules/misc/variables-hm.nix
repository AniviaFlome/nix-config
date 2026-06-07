{
  flake.modules.homeManager.variables =
    {
      pkgs,
      browser,
      file,
      term-editor,
      terminal,
      lib,
      ...
    }:
    {
      home.sessionVariables = {
        XDG_UTILS_DEFAULT_BROWSER = browser;
        XDG_UTILS_DEFAULT_TERMINAL = terminal;
        TERMINAL = terminal;
        XDG_UTILS_DEFAULT_FILE_MANAGER = file;
        EDITOR = term-editor;
        PAGER = lib.getExe pkgs.moor;
        MANPAGER = lib.getExe pkgs.moor;

        NIXPKGS_ALLOW_UNFREE = 1;

        PROTON_ENABLE_WAYLAND = 1;
        PROTON_USE_NTSYNC = 1;
        PROTON_DXVK_LOWLATENCY = 1;
        PROTON_DISCORD_BRIDGE = 1;

        MOZ_ENABLE_WAYLAND = 1;
        NIXOS_OZONE_WL = 1;
        _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      };
    };
}
