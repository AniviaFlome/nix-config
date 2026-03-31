{
  inputs,
  ...
}:
{
  imports = [ inputs.nix-webapps.homeManagerModules.default ];

  programs.nix-webapps = {
    enable = true;
    browser = "helium";
    isolate = false;
    apps = {
      "Zoom" = {
        url = "https://app.zoom.us/wc/home";
        mimeTypes = [
          "x-scheme-handler/zoommtg;x-scheme-handler/zoomus;x-scheme-handler/tel;x-scheme-handler/callto;x-scheme-handler/zoomphonecall;x-scheme-handler/zoomphonesms;x-scheme-handler/zoomcontactcentercall;application/x-zoom"
        ];
      };
    };
  };
}
