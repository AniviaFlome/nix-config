{
  inputs,
  ...
}:
let
  mkNixpkgs =
    input: system:
    import input {
      inherit system;
      config.allowUnfree = true;
    };
in
[
  inputs.firefox-addons.overlays.default
  inputs.helium.overlays.default
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.nix-repository.overlays.default
  inputs.nur.overlays.default
  inputs.waydroid-nvidia-nix.overlays.default
  inputs.millennium.overlays.default
  (final: prev: {
    stable = mkNixpkgs inputs.nixpkgs-stable final.stdenv.hostPlatform.system;
    master = mkNixpkgs inputs.nixpkgs-master final.stdenv.hostPlatform.system;
    bedrock-on-linux = inputs.bedrock-on-linux.packages.${final.stdenv.hostPlatform.system}.default;
    kopuz-flake = inputs.kopuz.packages.${final.stdenv.hostPlatform.system}.default;
    kdePackages = prev.kdePackages.overrideScope (
      _kfinal: kprev: {
        kde-gtk-config = kprev.kde-gtk-config.overrideAttrs (old: {
          postInstall = (old.postInstall or "") + ''
            rm -rf $out/lib/gtk-3.0/modules
          '';
        });
      }
    );
    qutebrowser = prev.qutebrowser.override {
      enableWideVine = true;
    };
    prismlauncher = prev.prismlauncher.override {
      additionalLibs = with prev; [
        bzip2
        curl
        openssl
        nss
      ];
      jdks = with prev; [
        javaPackages.compiler.openjdk25
        javaPackages.compiler.openjdk21
        temurin-bin-25
        temurin-bin-21
      ];
    };
    normcap = prev.symlinkJoin {
      name = prev.normcap.name;
      paths = with prev; [
        normcap
        grim
      ];
    };
    retroarch = prev.retroarch.withCores (
      cores: with cores; [
        melonds
        ppsspp
        np2kai
      ]
    );
  })
]
