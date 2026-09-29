{
  pkgs,
  ...
}:
{
  programs.mcp = {
    enable = true;
    servers = {
      nix = {
        command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
        args = [ ];
      };
      context7 = {
        command = "${pkgs.context7-mcp}/bin/context7-mcp";
        args = [ ];
      };
      agent-workspace = {
        command = "${pkgs.agent-workspace-linux}/bin/agent-workspace-linux";
        args = [ "mcp" ];
      };
      computer-use = {
        command = "${pkgs.computer-use-linux}/bin/computer-use-linux";
        args = [ "mcp" ];
      };
    };
  };

  home.packages = with pkgs; [
    agent-workspace-linux
    computer-use-linux
  ];
}
