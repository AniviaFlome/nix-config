{
  self,
  config,
  inputs,
  ...
}:
let
  m = config.flake.modules;
in
{
  flake.nixosConfigurations.liveiso-minimal = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs self; };
    modules = [
      m.nixos.documentation
      m.nixos.locale
      m.nixos.shell
      m.nixos.sudo-rs
      (
        { pkgs, lib, modulesPath, ... }:
        {
          imports = [
            "${modulesPath}/installer/cd-dvd/installation-cd-minimal-combined.nix"
          ];
          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          console.keyMap = "trq";
          environment.systemPackages =
            with pkgs;
            [
              curl
              disko
              git
              micro
              neovim
              parted
              rsync
            ]
            ++ lib.optional (inputs ? nixos-wizard) inputs.nixos-wizard.packages.${pkgs.system}.default;
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
          nixpkgs.config.allowUnfree = true;
          boot.supportedFilesystems.zfs = false;
          isoImage.squashfsCompression = "xz -Xdict-size 100%";
        }
      )
    ];
  };
}