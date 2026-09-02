{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          git
          just
          ripgrep

          # SoberLauncher runtime deps (from https://github.com/Taboulet/SoberLauncher)
          flatpak
          procps
          xdotool

          # Python with SoberLauncher deps for development
          (python3.withPackages (
            ps: with ps; [
              pyqt6
              requests
            ]
          ))

          # Python dev tools
          black
          pyright
          ruff
        ];
        shellHook = ''
          echo -e "\e[38;5;183mWelcome to my nix-config!\e[0m"
        '';
      };
    };
}
