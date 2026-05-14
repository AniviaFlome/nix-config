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
  inputs.niri.overlays.niri
  inputs.nix-repository.overlays.default
  inputs.nur.overlays.default
  inputs.llm-agents.overlays.default
  inputs.millennium.overlays.default
  (final: prev: {
    stable = mkNixpkgs inputs.nixpkgs-stable final.stdenv.hostPlatform.system;
    kopuz = inputs.kopuz.packages.${final.stdenv.hostPlatform.system}.default;
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
