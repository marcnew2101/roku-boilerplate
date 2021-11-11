sub getScreens()
    screens = {}
    for each screen in m.top.getScene().getChildren(-1, 0)
        if (screen.id <> Invalid AND len(screen.id) > 0)
            screens.addReplace(screen.id, screen)
        end if
    end for
    m.top.getScene().screens = screens
end sub

function setScreen(screen = Invalid)
    ' check that the argument/screen is not invalid
    if (screen <> Invalid)
        ' request the screen from the HomeScene interface
        request = m.top.getScene().screens[screen]
        ' check that the request is not invalid
        if (request <> Invalid)
            ' return the requested screen
            return m.top.getScene().screens[screen]
        else
            ' show an error stating the requested screen is not valid
            ? ""
            ? screen + " is not a valid node from HomeScene.xml"
            showAllScreens()
            return Invalid
        end if
    else
        showAllScreens()
    end if
end function

sub showAllScreens()
    ' show a list of valid screens on HomeScene
    ? ""
    ? "valid screens from HomeScene.brs:"
    for each screen in m.top.getScene().screens.items()
        ? screen.key
    end for
    ? ""
end sub