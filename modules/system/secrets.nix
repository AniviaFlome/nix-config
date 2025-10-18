{ username, ... }:

{
  security.pam.services.${username}.kwallet = {
    enable = true;
    forceRun = true;
  };
}
