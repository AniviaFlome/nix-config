{
  config,
  pkgs,
  ...
}:
let
  github-mcp = pkgs.writeShellScript "github-mcp-wrapper" ''
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(cat ${config.sops.secrets.github-mcp.path})"
    exec ${pkgs.github-mcp-server}/bin/github-mcp-server stdio
  '';
in
{
  programs.mcp = {
    enable = true;
    servers = {
      github = {
        command = "${github-mcp}";
        args = [ ];
      };
    };
  };
}
