hl.env("QSG_USE_SIMPLE_ANIMATION_DRIVER", "1")
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("hotkeyhub"), { description = "Hotkey cheat sheet" })

hl.monitor({
    output = "DP-1",
    mode = "1920x1080@300",
    position = "0x0",
    scale = 1,
})

hl.monitor({
    output = "DP-3",
    mode = "1920x1080@144.02",
    position = "1920x0",
    scale = 1.25,
})
