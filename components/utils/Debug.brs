function getAllScreens() as dynamic
    screenArray = m.scene.getChildren(-1, 0)
    if (screenArray <> invalid and screenArray.count() > 0)
        return screenArray
    else
        return invalid
    end if
end function

sub showAllScreens()
    screenArray = getAllScreens()
    if screenArray = invalid or screenArray.count() = 0
        logDebug("no valid screens/nodes in HomeScene", "Debug.brs")
        return
    end if

    logDebug("valid screens/nodes in HomeScene:", "Debug.brs")
    for each screen in screenArray
        logDebug(" -> " + screen.subType() + " (id=" + screen.id + ")", "Debug.brs")
    end for
end sub

sub getHistory()
    if not hasValue(m.screenStack)
        logDebug("screen stack is empty", "Debug.brs")
        return
    end if

    logDebug("screen stack contents:", "Debug.brs")
    for each node in m.screenStack
        logDebug(" -> " + node.subType() + " (id=" + node.id + ")", "Debug.brs")
    end for
end sub
