{ pkgs, config, ... }:
let
  inherit (builtins) concatStringsSep;

  box = pkgs.writers.writeNu "box" {
    makeWrapperArgs = with pkgs; [ "--prefix PATH : ${pkgs.lib.makeBinPath [ distrobox ]}" ];
  } (builtins.readFile ./distrobox.nu);

  mkBox =
    {
      name,
      image,
      exec ? "fish",
      copr_repos ? [ ],
    }:
    let
      homeDir = config.home.homeDirectory;

      pkgMgr =
        if name == "arch" then
          {
            check = "/bin/paru -Qq";
            install = "/bin/paru -S --noconfirm --needed";
            uninstall = "/bin/paru -Rs --noconfirm";
            setup = pkgs.writeShellScriptBin "paru-setup" ''
              if ! command -v paru >/dev/null; then
                sudo pacman -Sy --noconfirm
                sudo pacman -S --noconfirm --needed base-devel
                tmpdir="$(mktemp -d)"
                git clone https://aur.archlinux.org/paru-bin.git "$tmpdir"
                cd "$tmpdir"
                makepkg -si --noconfirm
                rm -rf "$tmpdir"
              fi
            '';
          }
        else if name == "debian" then
          {
            check = "dpkg -s";
            install = "sudo apt install -y";
            uninstall = "sudo apt remove -y";
            setup = pkgs.writeShellScriptBin "apt-setup" "";
          }
        else if name == "fedora" then
          {
            check = "rpm -q";
            install = "sudo dnf install -y";
            uninstall = "sudo dnf remove -y";
            setup = pkgs.writeShellScriptBin "dnf-setup" ''
              if ! rpm -q dnf-plugins-core >/dev/null 2>&1; then
                sudo dnf install -y dnf-plugins-core
              fi

              enabled_repos=$(dnf copr list | awk '{print $1}' | tr '/' ':')
              for repo in ${concatStringsSep " " copr_repos}; do
                repo=$(echo "$repo" | xargs)
                repo_id=$(echo "$repo" | tr '/' ':')
                # Check if repo is already enabled by searching in the enabled_repos variable
                if echo "$enabled_repos" | grep -qw "$repo_id"; then
                  continue
                else
                  sudo dnf copr enable -y "$repo" 2>&1
                fi
              done

              # Remove all other COPR repositories not in copr_repos
              copr_repos_str="${concatStringsSep " " copr_repos}"
              dnf copr list | awk '{print $1}' | grep -v -w -f <(echo "$copr_repos_str" | tr ' ' '\n') | while read -r repo; do
                sudo dnf copr remove -y "$repo"
              done

              # Add RPM Fusion Free and Non-Free repositories together if not already installed
              if ! rpm -q rpmfusion-free-release rpmfusion-nonfree-release >/dev/null 2>&1; then
                sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
              fi
            '';
          }
        else
          {
            check = "echo 'Unknown distribution' >&2";
          };

      db-exec = pkgs.writeShellScript "db-exec" ''
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

          mkdir -p "$(dirname "$STATE_FILE")"
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
    distrobox
    nushell

    (mkBox {
      name = "debian";
      image = "quay.io/toolbx-images/debian-toolbox:latest";
    })
    (mkBox {
      name = "fedora";
      image = "registry.fedoraproject.org/fedora-toolbox:rawhide";
      copr_repos = [
        "atim/starship"
        "relativesure/all-packages"
      ];
    })
    (mkBox {
      name = "arch";
      image = "docker.io/library/archlinux:latest";
    })
  ];
}
