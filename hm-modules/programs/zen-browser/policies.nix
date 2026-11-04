{
  EncryptedMediaExtensions = {
    Enabled = false;
    Locked = true;
  };
  ExtensionSettings =
    let
      mkExtensionSettings = builtins.mapAttrs (
        _: slug: {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${slug}/latest.xpi";
          installation_mode = "normal_installed";
        }
      );
    in
    mkExtensionSettings {
      "{4b7825da-0dd1-44f9-9717-bee5b2408af6}" = "always-visible";
      "reddit-unhider@siddh.dev" = "reddit-unhider";
    };
}
