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
        ];
        shellHook = ''
          echo -e "\e[38;5;183mWelcome to my nix-config!\e[0m"
        '';
      };
    };
}
