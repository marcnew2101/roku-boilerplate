function getScreen(screenId as string, showScreen = false as boolean)
    if screenId = invalid or len(screenId) = 0
        ? " "
        ? "you must set a valid id (string) for screenId"
        return invalid
    end if
    node = m.top.getScene().findNode(screenId)
    if node = invalid
        ? " "
        ? screenId + " was not found"
        return invalid
    end if
    if not node.visible and showScreen then node.visible = true
    return node
end function
function screenExists(screenId as string) as boolean
    if screenId = invalid or len(screenId) = 0
        ? " "
        ? "screen not found"
        return false
    end if
    return getScreen(screenId) <> invalid
end function
function addScreen(screenName as string, screenId = invalid as string, showScreen = true as boolean, hidePrevScreen = true as boolean, addToStack = true as boolean) as object
    ' check if screenId is invalid or empty
    if screenId = invalid or screenId.len() = 0
        ' assign the screenName to the screenId
        screenId = screenName
        ? " "
        ? "No screen ID assigned for " + screenName + " node. Using " + screenName + " as ID"
    end if
    ' check if the screenId is already been given to an existing screen node
    if screenExists(screenId)
        ? " "
        ? "The id '" + screenId + "' is already assigned to another screen node. Please create a new id for this node."
        ' refuse to add a duplicate; callers already null-check the return
        return invalid
    end if
    return m.top.getScene().callFunc("addNode", {"screenName": screenName, "showScreen": showScreen, "screenId": screenId, "hidePrevScreen": hidePrevScreen, "addToStack": addToStack})
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
    m.top.getScene().callFunc("removeNode", {"node": node, "showPrevScreen": showPrevScreen, "removeFromStack": removeFromStack})
end sub
function getAllScreens() as dynamic
    ' create a variable to store all of the child nodes from HomeScene
    screenArray = m.top.getScene().getChildren(-1, 0)
    ' check that the screen array is valid and has an item count of greater than zero
    if (screenArray <> invalid and screenArray.count() > 0)
        ' return the screen array
        return screenArray
    else
        return invalid
    end if
end function
sub showAllScreens()
    ' get the full array of child nodes from HomeScene
    screenArray = getAllScreens()
    ' check that the screen array is valid and has an item count of greater than zero
    if (screenArray <> invalid and screenArray.count() > 0)
        ? "valid screens/nodes from HomeScene.xml:"
        ' loop over each screen in the array and print to console
        for each screen in screenArray
            ? " -> " + screen
        end for
        ? " "
    else
        ' show a console message stating that there are no child nodes in HomeScene
        ? "there are no valid screens/nodes in HomeScene.xml:"
        ? " "
    end if
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
    if saveFocus then m.top.update({"focusedNode": focusedNode}, true)
end sub