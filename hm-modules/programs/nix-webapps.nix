{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-webapps.homeManagerModules.default ];

  programs.nix-webapps = {
    enable = true;
    browser = "brave";
    apps = {
      "Zoom" = {
        url = "https://app.zoom.us/wc/home";
        sha = "sha256-WLb+4aiD2beY3qnb+PJi+4h14DW/pXF5K4lnxMBDTSY=";
        mimeTypes = [
          "x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;x-scheme-handler/zoomphonesms;x-scheme-handler/zoomcontactcentercall;application/x-zoom"
        ];
      };
    };
  };
}
