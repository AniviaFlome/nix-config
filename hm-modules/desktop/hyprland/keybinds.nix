{
  wayland.windowManager.hyprland.extraConfig = ''
    local mainMod = "SUPER"

    -- window ops
    hl.bind(mainMod .. " + C", hl.dsp.window.kill())
    hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
    hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + Q", hl.dsp.group.toggle())

    -- exec
    hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
    hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("power-profiles-switch"))
    hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("dms ipc launcher toggle"))
    hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("dms ipc clipboard toggle"))
    hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("shell-selector toggle"))
    hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))

    -- screenshots
    hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("grimblast copy area"))
    hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("grimblast copy screen"))
    hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd("grimblast copy active"))

    -- focus directional
    hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))
    hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + A", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + D", hl.dsp.focus({ direction = "right" }))

    -- workspace cycling
    hl.bind(mainMod .. " + W", hl.dsp.focus({ workspace = "-1" }))
    hl.bind(mainMod .. " + S", hl.dsp.focus({ workspace = "+1" }))

    -- swap columns
    hl.bind(mainMod .. " + SHIFT + A", hl.dsp.layout("swapcol l"))
    hl.bind(mainMod .. " + SHIFT + D", hl.dsp.layout("swapcol r"))

    -- move columns
    hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.layout("move -col"))
    hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.layout("move +col"))

    -- move window up/down
    hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "u" }))
    hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "d" }))

    -- move to workspace -1 / +1
    hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.move({ workspace = "-1" }))
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "+1" }))

    -- mouse scroll
    hl.bind(mainMod .. " + mouse_down", hl.dsp.layout("focus r"))
    hl.bind(mainMod .. " + mouse_up", hl.dsp.layout("focus l"))
    hl.bind(mainMod .. " + SHIFT + mouse_down", hl.dsp.focus({ workspace = "+1" }))
    hl.bind(mainMod .. " + SHIFT + mouse_up", hl.dsp.focus({ workspace = "-1" }))

    -- workspace 1-9: focus and move-to
    for i = 1, 9 do
        hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    end

    -- mouse move/resize
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
  '';
}
