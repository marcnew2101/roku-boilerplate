sub setScreens()
    screens = {}
    for each screen in m.top.getScene().getChildren(-1, 0)
        if (screen.id <> Invalid AND len(screen.id) > 0)
            screens.addReplace(screen.id, screen)
        end if
    end for
    m.top.getScene().screens = screens
end sub

function getScreen(screen)
    return m.top.getScene().screens[screen]
end function