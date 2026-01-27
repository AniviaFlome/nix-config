{
  pkgs,
  ...
}:
{
  services.ollama = {
    enable = true;
    package = pkgs.stable.ollama-cuda;
    openFirewall = false;
    loadModels = [
      "mistral"
    ];
  };
}
