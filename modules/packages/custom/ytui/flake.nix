{
  description = "ytui - A TUI YouTube client written in Go";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        ytui = pkgs.buildGoModule {
          pname = "ytui";
          version = "unstable-2025-06-01";

          src = pkgs.fetchFromGitHub {
            owner = "Banh-Canh";
            repo = "ytui";
            rev = "main";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace with actual hash
          };

          vendorSha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # replace with actual vendor hash

          meta = with pkgs.lib; {
            description = "A TUI YouTube client written in Go";
            homepage = "https://github.com/Banh-Canh/ytui";
            license = licenses.mit;
            maintainers = with maintainers; [ ];
            platforms = platforms.unix;
          };
        };

      in {
        defaultPackage.${system} = packages.${system}.default;

        packages.default = ytui;
      });
}
