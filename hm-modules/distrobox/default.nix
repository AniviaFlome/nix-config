{ pkgs, config, ... }: let
  inherit (builtins) concatStringsSep filter typeOf readFile;

  box = pkgs.writers.writeNu "box" {
    makeWrapperArgs = with pkgs; [
      "--prefix PATH : ${pkgs.lib.makeBinPath [distrobox]}"
    ];
  } (builtins.readFile ./distrobox.nu);

  mkBox = {
    name,
    image,
    exec ? "bash",
    packages ? [],
    copr_repos ? [],
  }: let
    homeDir = config.home.homeDirectory;

    pkgMgr =
      if name == "arch" then {
        check = "/bin/paru -Qq";
        install = "/bin/paru -S --noconfirm --needed";
        uninstall = "/bin/paru -Rns --noconfirm";
        setup = pkgs.writeShellScriptBin "paru-setup" ''
          if ! command -v paru >/dev/null; then
            echo "Updating package databases..."
            sudo pacman -Sy --noconfirm
            sudo pacman -S --noconfirm --needed base-devel
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
        install = "LC_ALL=C sudo apt install -y";
        uninstall = "LC_ALL=C sudo apt remove -y";
        setup = pkgs.writeShellScriptBin "apt-setup" ''

        '';
      } else if name == "fedora" then {
        check = "rpm -q";
        install = "sudo dnf install -y";
        uninstall = "sudo dnf remove -y";
        setup = pkgs.writeShellScriptBin "dnf-setup" ''
          # Install dnf-plugins-core if missing
          if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
            sudo dnf install -y dnf-plugins-core
          fi

          # Enable specified COPR repositories
          for repo in ${concatStringsSep " " copr_repos}; do
            if ! dnf copr list | grep -q "^$repo"; then
              echo "Enabling COPR repository: $repo"
              sudo dnf copr enable -y "$repo"
            else
              echo "COPR repository $repo is already enabled."
            fi
          done

          # Remove all other COPR repositories not in copr_repos
          copr_repos_str="${concatStringsSep " " copr_repos}"
          dnf copr list | awk '{print $1}' | grep -v -w -f <(echo "$copr_repos_str" | tr ' ' '\n') | while read -r repo; do
            # echo "Removing COPR repository: $repo"
            sudo dnf copr remove -y "$repo"
          done
        '';
      } else {
        check = "echo 'Unknown distribution' >&2";
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
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8

      export XDG_DATA_DIRS="/usr/share:/usr/local/share"
      export PATH="${concatStringsSep ":" path}"

      # echo "=== Distrobox environment debug ==="
      # echo "Container name: ${name}"
      # echo "Package file: ${homeDir}/nix-config/hm-modules/distrobox/pkgs/${name}-pkgs.txt"
      # echo "Package manager: ${pkgMgr.install}"

      ${pkgMgr.setup}/bin/${pkgMgr.setup.name}

      PKG_FILE="${homeDir}/nix-config/hm-modules/distrobox/pkgs/${name}-pkgs.txt"
      STATE_FILE="${homeDir}/.local/share/distrobox/${name}/.distrobox_installed_pkgs_${name}.txt"

      if [ -f "$PKG_FILE" ]; then
        # echo "Checking for packages to install..."
        packages_to_install=""
        while read -r pkg; do
          [[ "$pkg" =~ ^#.* || -z "$pkg" ]] && continue
          if ! ${pkgMgr.check} "$pkg" >/dev/null 2>&1; then
            packages_to_install="$packages_to_install $pkg"
          fi
        done < "$PKG_FILE"

        if [ -n "$packages_to_install" ]; then
          # echo "Installing packages: $packages_to_install"
          ${pkgMgr.install} $packages_to_install || echo "Failed to install some packages"
        else
          echo "No new packages to install."
        fi

        if [ -f "$STATE_FILE" ]; then
          # echo "Checking for packages to remove..."
          while read -r oldpkg; do
            if ! grep -qx "$oldpkg" "$PKG_FILE"; then
              # echo "Removing package: $oldpkg"
              ${pkgMgr.uninstall} $oldpkg || echo "Failed to remove $oldpkg"
            fi
          done < "$STATE_FILE"
        fi

        cp "$PKG_FILE" "$STATE_FILE"
      else
        echo "No package file found at $PKG_FILE"
        echo "Create one with: mkdir -p $(dirname "$PKG_FILE") && touch $PKG_FILE"
      fi

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
in

{
  home.packages = with pkgs; [
    nushell
    distrobox
    (mkBox {
      name = "debian";
      image = "quay.io/toolbx-images/debian-toolbox:latest";
    })
    (mkBox {
      name = "fedora";
      image = "registry.fedoraproject.org/fedora-toolbox:rawhide";
      copr_repos = [ "atim/starship" ];
    })
    (mkBox {
      name = "arch";
      image = "docker.io/library/archlinux:latest";
    })
  ];
}
