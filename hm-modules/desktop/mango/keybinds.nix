{
  clipboard,
  file,
  launcher,
  terminal,
  ...
}:
{
  wayland.windowManager.mango.settings = {
    bind = [
      "SUPER,c,killclient"
      "SUPER,g,toggleoverview"
      "SUPER,m,togglemaximizescreen"
      "SUPER,e,spawn,${file}"
      "SUPER,t,spawn,${terminal}"
      "SUPER,b,spawn,power-profiles-switch"
      "SUPER,space,spawn,${launcher}"
      "SUPER,h,spawn,${clipboard}"
      "SUPER,f,togglemaximizescreen"
      "SUPER+SHIFT,f,togglefullscreen"
      "SUPER,v,togglefloating"
      "SUPER,q,groupjoin,left"
      "SUPER,l,spawn,screenshot-to-waytator"
      "SUPER,p,spawn_shell,grim -g \"$(slurp -d)\" - | wl-copy"
      "SUPER+SHIFT,p,spawn_shell,grim - | wl-copy"
      "SUPER+CTRL,p,spawn_shell,g=$(mmsg get focusing-client | jq -r '\"\\(.x),\\(.y) \\(.width)x\\(.height)\"') && grim -g \"$g\" - | wl-copy"
      "SUPER,Up,focusdir,up"
      "SUPER,Left,focusdir,left"
      "SUPER,Down,focusdir,down"
      "SUPER,Right,focusdir,right"
      "SUPER,w,viewtoleft"
      "SUPER,a,focusdir,left"
      "SUPER,s,viewtoright"
      "SUPER,d,focusdir,right"
      "SUPER+SHIFT,w,tagtoleft"
      "SUPER+SHIFT,a,move_client,left"
      "SUPER+SHIFT,s,tagtoright"
      "SUPER+SHIFT,d,move_client,right"
      "SUPER+SHIFT,Up,move_client,up"
      "SUPER+SHIFT,Left,move_client,left"
      "SUPER+SHIFT,Down,move_client,down"
      "SUPER+SHIFT,Right,move_client,right"
      "SUPER,o,spawn,shell-selector toggle"
      "SUPER,1,view,1"
      "SUPER,2,view,2"
      "SUPER,3,view,3"
      "SUPER,4,view,4"
      "SUPER,5,view,5"
      "SUPER,6,view,6"
      "SUPER,7,view,7"
      "SUPER,8,view,8"
      "SUPER,9,view,9"
      "SUPER+SHIFT,1,tag,1"
      "SUPER+SHIFT,2,tag,2"
      "SUPER+SHIFT,3,tag,3"
      "SUPER+SHIFT,4,tag,4"
      "SUPER+SHIFT,5,tag,5"
      "SUPER+SHIFT,6,tag,6"
      "SUPER+SHIFT,7,tag,7"
      "SUPER+SHIFT,8,tag,8"
      "SUPER+SHIFT,9,tag,9"
    ];
    axisbind = [
      "SUPER,UP,focusdir,left"
      "SUPER,DOWN,focusdir,right"
      "SUPER+SHIFT,UP,viewtoleft"
      "SUPER+SHIFT,DOWN,viewtoright"
    ];
    mousebind = [
      "SUPER,btn_left,moveresize,curmove"
      "SUPER,btn_right,moveresize,curresize"
    ];
  };
}
