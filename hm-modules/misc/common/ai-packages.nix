{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    agent-workspace-linux
    ctx7
    playwright-test
  ];
}
