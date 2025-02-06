{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
  (prismlauncher.override {
    additionalLibs = [
      bzip2
      openssl
      nss
      nspr
    ];
    jdks = [
      zulu8
      zulu17
      zulu
    ];
  })
  ];
}
