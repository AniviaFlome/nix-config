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
      Github = {
        command = "${github-mcp}";
        args = [ ];
      };
      nix = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
      context7 = {
        command = "${pkgs.context7-mcp}/bin/context7-mcp";
        args = [ ];
      };
    };
  };
}
