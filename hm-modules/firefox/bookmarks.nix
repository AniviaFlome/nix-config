{ username, ... }:

{
  programs.firefox = {
    profiles.${username} = {
      bookmarks = [
{
    name = "Youtube";
    url = "https://www.youtube.com/";
}
      ];
    };
  };
}
