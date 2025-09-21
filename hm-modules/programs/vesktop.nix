{ inputs, ... }:

{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    discord.enable = false;
    vesktop.enable = true;
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
        experiments.enable = true;
        expressionCloner.enable = true;
        fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        fixYoutubeEmbeds.enable = true;
        iLoveSpam.enable = true;
        imageZoom = {
          enable = true;
          size = 3000.0;
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
