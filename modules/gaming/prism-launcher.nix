{
  pkgs,
  ...
}:
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
        temurin-jre-bin-21
        temurin-jre-bin-17
        temurin-jre-bin-8
      ];
    })
  ];
}
