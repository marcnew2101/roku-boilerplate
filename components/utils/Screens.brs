function getScreen(screenId as string, showScreen = false as boolean)
    ' check that the argument for screenId is valid and has a string length greater than zero
    if (screenId <> invalid and len(screenId) > 0)
        ' find the node
        node = m.top.getScene().findNode(screenId)
        ' check that the node is valid
        if (node <> invalid)
            ' show the node if the node is not visible and the showScreen argument is true
            if not node.visible and showScreen then node.visible = true
            ' return the requested node
            return node
        else
            ' show a console message stating the requested screen/node is not valid
            ? " "
            ? screenId + " was not found"
            return invalid
        end if
    else
        ' show a console message stating that getScreen requires a valid screenId
        ? " "
        ? "you must set a valid id (string) for screenId"
    end if
end function
function screenExists(screenId as string) as boolean
    ' ensure screenId is valid and not an empty string
    if (screenId <> invalid and len(screenId) > 0)
        ' get the screen node
        node = getScreen(screenId)
        if node <> invalid then return true
    else
        ? " "
        ? "screen not found"
    end if
    return false
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
        ' assign an empty string to the screenId
        screenId = ""
    end if
    return m.top.getScene().callFunc("addNode", {"screenName": screenName, "showScreen": showScreen, "screenId": screenId, "hidePrevScreen": hidePrevScreen, "addToStack": addToStack})
end function
sub removeScreen(screen = invalid as dynamic, showPrevScreen = true as boolean, removeFromStack = true as boolean)
    ' check that screen is valid
    if (screen <> invalid)
        ' set initial node value
        node = invalid
        ' check if the screen is a node type
        if (type(screen) = "roSGNode")
            ' set the node value
            node = screen
        ' check if the screen is a string type
        else if (type(screen) = "String" and len(screen) > 0)
            ' find the node and set the return valud
            node = getScreen(screen)
        end if
        ' check if the node is valid
        if (node <> invalid)
            ' call the removeNode function on the HomeScene interface
            m.top.getScene().callFunc("removeNode", {"node": node, "showPrevScreen": showPrevScreen, "removeFromStack": removeFromStack})
        end if
    end if
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
    ' check that node is valid
    if (node <> invalid)
        ' set initial focusedNode value
        focusedNode = invalid
        ' check if the node is a node type
        if (type(node) = "roSGNode")
            ' set the focusedNode value
            focusedNode = node
        ' check if the node is a string type
        else if (type(node) = "String" and len(node) > 0)
            ' find the node and set the return valud
            focusedNode = getScreen(node)
        end if
        ' check if the focusedNode is valid
        if (focusedNode <> invalid)
            ' set focus to node
            focusedNode.setFocus(true)
            ' check if saveFocus is true and set HomeScene node interface
            if saveFocus then m.top.update({"focusedNode": focusedNode}, true)
        end if
    end if
end sub