{
  inputs,
  ...
}:
[
  inputs.firefox-addons.overlays.default
  inputs.nix-cachyos-kernel.overlays.pinned
  inputs.nix-repository.overlays.default
  inputs.nur.overlays.default
  inputs.llm-agents.overlays.default
  (final: prev: {
    stable = import inputs.nixpkgs-stable {
      inherit (final.stdenv.hostPlatform) system;
      config = {
        allowUnfree = true;
      };
    };
    helium = prev.nur.repos.Ev357.helium.override {
      enableWideVine = true;
    };
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
        temurin-bin-17
        temurin-bin-8
      ];
    };
    retroarch = prev.retroarch.withCores (
      cores: with cores; [
        melonds
        ppsspp
        np2kai
      ]
    );
    pkgs-millennium = import inputs.nixpkgs-millennium {
      inherit (final.stdenv.hostPlatform) system;
      config = {
        allowUnfree = true;
      };
    };
    inherit (final.pkgs-millennium) steam-millennium;
  })
]
