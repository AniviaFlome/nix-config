#!/bin/bash

pkg_file="./arch/pkgs.txt"

if [[ ! -f "$pkg_file" ]]; then
    echo "Error: Package list file '$pkg_file' not found."
    exit 1
fi

while IFS= read -r package || [[ -n "$package" ]]; do
    # Skip empty lines and lines starting with '#'
    if [[ -z "$package" ]] || [[ "$package" =~ ^# ]]; then
        continue
    fi

    if pacman -Qi "$package" &>/dev/null; then
        echo "Package '$package' is already installed. Skipping..."
    else
        echo "Installing package '$package'..."
        sudo pacman -S --noconfirm "$package"
    fi
done < "$pkg_file"
