#!/usr/bin/env bash

if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed. Please install it first."
    exit 1
fi

echo "Select project type:"
types=(
  "python"
  "rust"
  "go"
  "node"
  "default"
)
type=$(gum choose "${types[@]}")

if [ -z "$type" ]; then
    echo "No selection made."
    exit 1
fi

case $type in
    python)
        nix flake new -t github:nix-community/nix-direnv . 
        ;;
    rust)
        nix flake new -t github:ipetkov/crane .
        ;;
    go)
        nix flake new -t github:nix-community/templates#go-hello .
        ;;
    node)
        nix flake new -t github:nix-community/templates#simple-node .
        ;;
    default)
        cat <<EOF > shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    git
    curl
    wget
    jq
    ripgrep
    fzf
    bat
    lsd
    btop
  ];

  shellHook = ''
    echo "Welcome to your development environment!"
  '';
}
EOF
        echo "Created shell.nix with common dev tools."
        ;;
    *)
        echo "Invalid selection"
        exit 1
        ;;
esac

if [ "$type" != "default" ]; then
    echo "❄️  Flake created."
fi