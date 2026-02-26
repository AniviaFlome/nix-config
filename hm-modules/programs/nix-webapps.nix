{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-webapps.homeManagerModules.default ];

  programs.nix-webapps = {
    enable = true;
    browser = "helium";
    apps = {
      "Google Meet" = {
        url = "https://meet.google.com/landing";
        sha = "sha256-Q4h4+TmzKhatDREflZmmt2Bc5524ElcYdc89hxDCdtE=";
      };
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
