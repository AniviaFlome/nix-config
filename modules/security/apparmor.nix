{
  pkgs,
  ...
}:
{
  security.apparmor = {
    enable = true;
    enableCache = false;
    killUnconfinedConfinables = false;
    packages = with pkgs; [
      apparmor-profiles
    ];
  };
}
