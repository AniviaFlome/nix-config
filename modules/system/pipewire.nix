{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "10-obs-sink" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Duplex #1";
              "media.class" = "Audio/Duplex";
              "node.description" = "Output/Input #1";
              "audio.position" = "MONO";
            };
          }
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = "Duplex #2";
              "media.class" = "Audio/Duplex";
              "node.description" = "Output/Input #2";
              "audio.position" = "MONO";
            };
          }
        ];
      };
    };
  };

  security.rtkit.enable = true;
}
