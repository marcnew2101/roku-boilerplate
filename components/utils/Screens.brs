function getScreen(screenId as string, showScreen = false as boolean)
    if not hasValue(screenId)
        logError("invalid screenId passed to getScreen", "Screens.brs")
        return invalid
    end if

    node = m.scene.findNode(screenId)
    if node = invalid
        logWarn(screenId + " was not found", "Screens.brs")
        return invalid
    end if
    if not node.visible and showScreen then node.visible = true
    return node
end function

function screenExists(screenId as string) as boolean
    if not hasValue(screenId)
        logError("invalid screenId passed to screenExists", "Screens.brs")
        return false
    end if
    ' direct findNode avoids the "not found" warn that getScreen emits on miss;
    ' callers using screenExists are intentionally probing for an unknown screen
    return m.scene.findNode(screenId) <> invalid
end function

function addScreen(screenName as string, screenId = invalid as string, showScreen = true as boolean, hidePrevScreen = true as boolean, addToStack = true as boolean) as object
    if not hasValue(screenId)
        screenId = screenName
        logInfo("no screen id assigned for " + screenName + " node; using " + screenName + " as id", "Screens.brs")
    end if
    if screenExists(screenId)
        logError("id '" + screenId + "' already assigned to another screen node", "Screens.brs")
        return invalid
    end if
    return m.scene.callFunc("addNode", {"screenName": screenName, "showScreen": showScreen, "screenId": screenId, "hidePrevScreen": hidePrevScreen, "addToStack": addToStack})
end function

sub removeScreen(screen = invalid as dynamic, showPrevScreen = true as boolean, removeFromStack = true as boolean)
    if screen = invalid then return
    node = invalid
    if type(screen) = "roSGNode"
        node = screen
    else if type(screen) = "String" and len(screen) > 0
        node = getScreen(screen)
    end if

    if node = invalid then return
    m.scene.callFunc("removeNode", {"node": node, "showPrevScreen": showPrevScreen, "removeFromStack": removeFromStack})
end sub

function getAllScreens() as dynamic
    ' create a variable to store all of the child nodes from HomeScene
    screenArray = m.scene.getChildren(-1, 0)
    ' check that the screen array is valid and has an item count of greater than zero
    if (screenArray <> invalid and screenArray.count() > 0)
        ' return the screen array
        return screenArray
    else
        return invalid
    end if
end function

sub showAllScreens()
    screenArray = getAllScreens()
    if screenArray = invalid or screenArray.count() = 0
        logDebug("no valid screens/nodes in HomeScene", "Screens.brs")
        return
    end if

    logDebug("valid screens/nodes in HomeScene:", "Screens.brs")
    for each screen in screenArray
        logDebug(" -> " + screen.subType() + " (id=" + screen.id + ")", "Screens.brs")
    end for
end sub

sub setFocus(node as dynamic, saveFocus = true as boolean)
    if node = invalid then return
    focusedNode = invalid
    if type(node) = "roSGNode"
        focusedNode = node
    else if type(node) = "String" and len(node) > 0
        focusedNode = getScreen(node)
    end if

    if focusedNode = invalid then return
    focusedNode.setFocus(true)
    ' createFields=true keeps non-BaseScreen callers (e.g. HomeScene) working
    if saveFocus
        m.top.update({"focusedNode": focusedNode}, true)
    end if
end sub