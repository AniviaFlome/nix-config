{
  wayland.windowManager.mango.settings = {
    border = {
      px = 3;
      color = "0x505050ff";
      radius = 0;
    };
    focus = {
      color = "0xcba6f7ff";
      on_activate = 1;
    };
    focused = {
      opacity = 1.0;
    };
    unfocused = {
      opacity = 1.0;
    };
    urgent = {
      color = "0xf38ba8ff";
    };
    root = {
      color = "0x181825ff";
    };
    maximized = {
      screen_color = "0xcba6f7ff";
    };
    scratchpad = {
      color = "0xcba6f7ff";
    };
    global = {
      color = "0xcba6f7ff";
    };
    overlay = {
      color = "0xcba6f7ff";
    };
    no_radius_when_single = 0;
    gap = {
      inner = {
        horizontal = 6;
        vertical = 6;
      };
      outer = {
        horizontal = 4;
        vertical = 4;
      };
    };
    blur = 1;
    blur_optimized = 1;
    blur_params = {
      radius = 3;
      num_passes = 3;
      noise = 0.02;
      saturation = 1.5;
    };
    animation = {
      duration = {
        open = 150;
        close = 150;
        move = 250;
        tag = 200;
        focus = 0;
      };
      curve = {
        open = "0.16,1,0.3,1";
        close = "0.25,0.46,0.45,0.94";
      };
      type = {
        open = "zoom";
        close = "zoom";
      };
    };
    animation_fade_in = 1;
    animation_fade_out = 1;
    sloppy = {
      focus = 0;
    };
    disable = {
      middle_paste = 1;
    };
    numlock = {
      on = 1;
    };
    xkb = {
      rules = {
        layout = "tr";
      };
    };
    trackpad = {
      disable_while_typing = 1;
      natural_scrolling = 0;
      send_events_mode = 0;
    };
    mouse = {
      natural_scrolling = 0;
    };
    xwayland = {
      ignore_scale = 1;
    };
    tag = {
      num = 9;
      animation = {
        direction = 0;
      };
      rule = [
        "id:*,layout_name:scroller"
      ];
    };
    scroller = {
      prefer_center = 1;
      prefer_overspread = 0;
    };
    circle = {
      layout = "scroller,tile,monocle,grid";
    };
    monitor = {
      rule = [
        "name:^eDP-1$,width:1920,height:1080,refresh:144.063,x:0,y:0,scale:1.25,vrr:1,primary:1"
      ];
    };
    env = [
      "QT_QPA_PLATFORM,wayland"
      "QT_QPA_PLATFORMTHEME,kde"
      "MOZ_ENABLE_WAYLAND,1"
      "NIXOS_OZONE_WL,1"
    ];
    window = {
      rule = [
        "ignore_maximize:1,app_id:.*"
        "force_tiled_state:1,app_id:.*"
        "is_floating:1,title:^Picture-in-Picture$"
        "is_floating:1,app_id:^dev\\.faetalize\\.waytator$"
        "focused_opacity:0.9,unfocused_opacity:0.9,app_id:^kitty$"
      ];
    };
    layer = {
      rule = [
        "shield_when_capture:1,layer_name:^dms:clipboard$"
      ];
    };
    axis = {
      bind_apply_timeout = 150;
    };
  };
}
