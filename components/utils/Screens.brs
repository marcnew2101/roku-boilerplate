' Caller-facing API for screen lifecycle. Screens are identified by component subType();
' add/remove call into History.brs via callFunc on HomeScene — see README for the layering.

function getScreen(screenName as string, showScreen = false as boolean)
    if not hasValue(screenName)
        logError("invalid screenName passed to getScreen", "Screens.brs")
        return invalid
    end if

    node = findScreenBySubtype(screenName)
    if node = invalid
        logWarn(screenName + " was not found", "Screens.brs")
        return invalid
    end if
    if not node.visible and showScreen
        node.visible = true
    end if
    return node
end function

function screenExists(screenName as string) as boolean
    if not hasValue(screenName)
        logError("invalid screenName passed to screenExists", "Screens.brs")
        return false
    end if
    ' direct subtype walk avoids the "not found" warn that getScreen emits on miss;
    ' callers using screenExists are intentionally probing for an unknown screen
    return findScreenBySubtype(screenName) <> invalid
end function

function addScreen(screenName as string, showScreen = true as boolean, hidePrevScreen = true as boolean, trackInHistory = true as boolean) as object
    if not hasValue(screenName)
        logError("invalid screenName passed to addScreen", "Screens.brs")
        return invalid
    end if
    if screenExists(screenName)
        logError("a screen of type '" + screenName + "' already exists", "Screens.brs")
        return invalid
    end if
    return scene().callFunc("addToStack", {"screenName": screenName, "showScreen": showScreen, "hidePrevScreen": hidePrevScreen, "trackInHistory": trackInHistory})
end function

function findScreenBySubtype(screenName as string) as object
    for each child in scene().getChildren(-1, 0)
        if child.subType() = screenName then return child
    end for
    return invalid
end function

sub removeScreen(screen = invalid as dynamic, showPrevScreen = true as boolean, untrackHistory = true as boolean)
    if screen = invalid then return
    node = invalid
    if type(screen) = "roSGNode"
        node = screen
    else if type(screen) = "String" and len(screen) > 0
        node = getScreen(screen)
    end if

    if node = invalid then return
    scene().callFunc("removeFromStack", {"node": node, "showPrevScreen": showPrevScreen, "untrackHistory": untrackHistory})
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