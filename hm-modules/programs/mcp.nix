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
    };
  };
}
