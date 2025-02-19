{ pkgs, config, ... }: let
  inherit (builtins) concatStringsSep filter typeOf readFile;
  inherit (import ./distrobox pkgs) box;

  mkBox = {
    name,
    image,
    exec ? "fish",
    packages ? [],
  }: let
    # Get the user's home directory from Nix configuration
    homeDir = config.home.homeDirectory;

    # Package manager configuration
    pkgMgr =
      if name == "arch" then {
        check = "/bin/paru -Qq";
        install = "/bin/paru -S --noconfirm --needed";
        setup = pkgs.writeShellScriptBin "paru-setup" ''
          if ! command -v paru >/dev/null; then
            echo "Installing paru..."
            tmpdir="$(mktemp -d)"
            git clone https://aur.archlinux.org/paru-bin.git "$tmpdir"
            cd "$tmpdir"
            makepkg -si --noconfirm
            rm -rf "$tmpdir"
          fi
        '';
      } else if name == "debian" then {
        check = "dpkg -s";
        install = "sudo apt-get update && sudo apt-get install -y";
        setup = pkgs.writeShellScriptBin "apt-setup" "";
      } else name == "fedora" then {
        check = "rpm -q";
        install = "sudo dnf install -y";
        setup = pkgs.writeShellScriptBin "dnf-setup" "";
      };

    distropkgs = concatStringsSep " " (filter
      (p: typeOf p == "string")
      (packages ++ ["wl-clipboard" "git"]));

    path =
      [
        "/bin"
        "/sbin"
        "/usr/bin"
        "/usr/sbin"
        "/usr/local/bin"
        "$HOME/.local/bin"
      ]
      ++ (map (p: "${p}/bin") (filter (p: typeOf p == "set") packages));

    db-exec = pkgs.writeShellScript "db-exec" ''
      export XDG_DATA_DIRS="/usr/share:/usr/local/share"
      export PATH="${builtins.concatStringsSep ":" path}"

      # Debugging information
      echo "=== Distrobox environment debug ==="
      echo "Container name: ${name}"
      echo "Package file: ${homeDir}/nix-config/hm-modules/distrobox/${name}/pkgs.txt"
      echo "Package manager: ${pkgMgr.install}"

      # Run distribution-specific setup
      ${pkgMgr.setup}/bin/${pkgMgr.setup.name}

      # Package installation
      PKG_FILE="${homeDir}/nix-config/hm-modules/distrobox/${name}/pkgs.txt"
      if [ -f "$PKG_FILE" ]; then
        echo "Checking for packages to install..."
        while read -r pkg; do
          # Skip comments and empty lines
          [[ "$pkg" =~ ^#.* || -z "$pkg" ]] && continue

          # Check if package is installed
          if ! ${pkgMgr.check} "$pkg" >/dev/null 2>&1; then
            echo "Installing package: $pkg"
            if ! ${pkgMgr.install} "$pkg"; then
              echo "Failed to install $pkg" >&2
              exit 1
            fi
          else
            echo "Package already installed: $pkg"
          fi
        done < "$PKG_FILE"
      else
        echo "No package file found at $PKG_FILE"
        echo "Create one with: mkdir -p $(dirname "$PKG_FILE") && touch $PKG_FILE"
      fi

      # Start shell
      if [ $# -eq 0 ]; then
        ${exec}
      else
        bash -c "$@"
      fi
    '';
  in
    pkgs.writeShellScriptBin name ''
      ${box} ${name} ${image} ${db-exec} "$@"
    '';

# Packages options are not used but they are there if ypı want to use distrobox's native package install option
in {
  home.packages = with pkgs; [
    nushell
    distrobox
    (mkBox {
      name = "debian";
      image = "quay.io/toolbx-images/debian-toolbox:latest";
      # packages = ["atuin" "fastfetch" "zoxide"];
    })
    (mkBox {
      name = "fedora";
      image = "registry.fedoraproject.org/fedora-toolbox:rawhide";
      # packages = ["atuin" "fastfetch" "zoxide"];
    })
    (mkBox {
      name = "arch";
      image = "docker.io/library/archlinux:latest";
      # packages = ["atuin" "base-devel" "fastfetch" "zoxide"];
    })
  ];
}
