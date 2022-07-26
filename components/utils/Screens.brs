function getScreen(screen = invalid)
    ' check that the argument/screen is not invalid
    if (screen <> invalid)
        ' request the screen from the HomeScene interface
        request = m.top.getScene().findNode(screen)
        ' check that the request is not invalid
        if (request <> invalid)
            ' return the requested screen
            return request
        else
            ' show an error stating the requested screen is not valid
            ? ""
            ? screen + " is not a valid node from HomeScene.xml"
            return invalid
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
        ? "  " + screen.key
    end for
    ? ""
end sub