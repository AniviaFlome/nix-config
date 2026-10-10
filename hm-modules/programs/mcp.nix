{
  pkgs,
  ...
}:
{
  programs.mcp = {
    enable = true;
    servers = {
      agent-workspace = {
        command = "${pkgs.agent-workspace-linux}/bin/agent-workspace-linux";
        args = [ "mcp" ];
      };
      nix = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
      reddit-mcp-buddy = {
        command = "${pkgs.reddit-mcp-buddy}/bin/reddit-mcp-buddy";
        args = [ ];
      };
      mobile-mcp = {
        command = "${pkgs.mobile-mcp}/bin/mcp-server-mobile";
        args = [ ];
      };
    };
  };
}
