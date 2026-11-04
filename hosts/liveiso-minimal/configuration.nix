{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/system/documentation.nix
    ../../modules/system/locale.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.kernelParams = [ "video=1920x1080" ];

  console.colors = [
    "1e1e2e"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "f5c2e7"
    "94e2d5"
    "bac2de"
    "585b70"
    "f38ba8"
    "a6e3a1"
    "f9e2af"
    "89b4fa"
    "f5c2e7"
    "94e2d5"
    "a6adc8"
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
    # keep-sorted start case=no
    btrfs-progs
    comma
    curl
    ddrescue
    disko
    efibootmgr
    git
    micro
    neovim
    ntfs3g
    opencode
    parted
    rsync
    sbctl
    # keep-sorted end
  ];

  isoImage.squashfsCompression = "zstd -Xcompression-level 19";
}
