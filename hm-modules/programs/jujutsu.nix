{
  config,
  username,
  ...
}:
{
  programs.jjui = {
    enable = true;
  };

  programs.jujutsu = {
    enable = true;
    settings = {
      email = config.sops.secrets."mail".path;
      name = username;

      aliases = {
        ".." = [
          "edit"
          "@-"
        ];
        ",," = [
          "edit"
          "@+"
        ];
        fetch = [
          "git"
          "fetch"
        ];
        f = [
          "git"
          "fetch"
        ];
        push = [
          "git"
          "push"
        ];
        p = [
          "git"
          "push"
        ];
        clone = [
          "git"
          "clone"
        ];
        cl = [
          "git"
          "clone"
        ];
        init = [
          "git"
          "init"
        ];
        i = [
          "git"
          "init"
        ];
        a = [ "abandon" ];
        c = [ "commit" ];
        ci = [
          "commit"
          "--interactive"
        ];
        d = [ "diff" ];
        e = [ "edit" ];
        l = [ "log" ];
        la = [
          "log"
          "--revisions"
          "::"
        ];
        r = [ "rebase" ];
        res = [ "resolve" ];
        resolve-ast = [
          "resolve"
          "--tool"
          "mergiraf"
        ];
        resa = [ "resolve-ast" ];
        s = [ "squash" ];
        si = [
          "squash"
          "--interactive"
        ];
        sh = [ "show" ];
        tug = [
          "bookmark"
          "move"
          "--from"
          "closest(@-)"
          "--to"
          "closest_pushable(@)"
        ];
        t = [ "tug" ];
        u = [ "undo" ];
      };
    };
  };
}
