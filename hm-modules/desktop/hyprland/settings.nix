{
  wayland.windowManager.hyprland.extraConfig = ''
    -- Monitors
    -- See https://wiki.hypr.land/Configuring/Basics/Monitors/
    hl.monitor({
        output = "eDP-1",
        mode = "1920x1080@144.063",
        position = "0x0",
        scale = 1.25,
        vrr = true,
    })

    hl.config({
        input = {
            kb_layout = "tr",
            numlock_by_default = true,
            follow_mouse = 1,
            sensitivity = 0,
            accel_profile = "flat",
            touchpad = {
                disable_while_typing = true,
                natural_scroll = false,
                tap_to_click = true,
            },
        },

        general = {
            layout = "scrolling",
            gaps_in = 3,
            gaps_out = 6,
            border_size = 3,
            ["col.active_border"] = "rgba(cba6f7ff)",
            ["col.inactive_border"] = "rgba(505050ff)",
        },

        decoration = {
            rounding = 0,
            blur = {
                enabled = true,
                size = 3,
                passes = 1,
                new_optimizations = true,
            },
            shadow = {
                enabled = true,
                range = 4,
                render_power = 3,
                color = "rgba(1a1a1aee)",
            },
        },

        scrolling = {
            fullscreen_on_one_column = true,
            column_width = 0.8,
            direction = "right",
        },

        dwindle = {
            preserve_split = true,
        },

        master = {
            new_status = "slave",
        },

        misc = {
            force_default_wallpaper = 0,
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
        },

        ecosystem = {
            no_update_news = true,
            no_donation_nag = true,
        },

        cursor = {
            no_warps = true,
        },
    })

    hl.curve("niriExpo",   { type = "bezier", points = { { 0.16, 1 },    { 0.30, 1 } } })
    hl.curve("niriQuad",   { type = "bezier", points = { { 0.25, 0.46 }, { 0.45, 0.94 } } })
    hl.curve("niriCubic",  { type = "bezier", points = { { 0.33, 1 },    { 0.68, 1 } } })

    hl.window_rule({
        match = { title = "Picture-in-Picture" },
        float = true,
        pin = true,
        keep_aspect_ratio = true,
    })

    hl.env("QT_QPA_PLATFORM", "wayland")
    hl.env("QT_QPA_PLATFORMTHEME", "kde")
    hl.env("MOZ_ENABLE_WAYLAND", "1")
    hl.env("NIXOS_OZONE_WL", "1")
  '';
}
