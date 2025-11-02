{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = false;
    discord.enable = false;
    vesktop = {
      enable = true;
      package = with pkgs; vesktop;
    };
    config = {
      useQuickCss = true;
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-mocha-mauve.theme.css"
      ];
      plugins = {
        alwaysTrust.enable = true;
        anonymiseFileNames.enable = true;
        betterGifAltText.enable = true;
        callTimer.enable = true;
        clearURLs.enable = true;
        crashHandler.enable = true;
        customIdle = {
          enable = true;
          idleTimeout = 0.0;
        };
        experiments.enable = true;
        expressionCloner.enable = true;
        fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        fixYoutubeEmbeds.enable = true;
        iLoveSpam.enable = true;
        imageZoom = {
          enable = true;
          size = 30.0;
        };
        messageLogger.enable = true;
        noF1.enable = true;
        noOnboardingDelay.enable = true;
        noTypingAnimation.enable = true;
        permissionsViewer.enable = true;
        petpet.enable = true;
        pictureInPicture.enable = true;
        showHiddenThings.enable = true;
        summaries.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        volumeBooster.enable = true;
        webKeybinds.enable = true;
        webScreenShareFixes.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
