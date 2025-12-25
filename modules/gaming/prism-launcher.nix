{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (pkgs.prismlauncher.override {
      additionalLibs = [
        bzip2
        openssl
        nss
        nspr
      ];

      jdks = [
        javaPackages.compiler.temurin-bin.jre-25
        javaPackages.compiler.temurin-bin.jre-21
        javaPackages.compiler.temurin-bin.jre-17
        javaPackages.compiler.temurin-bin.jre-8
      ];
    })
  ];
}
