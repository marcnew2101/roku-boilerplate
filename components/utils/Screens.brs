function getScreen(screenId as string, showScreen = false as boolean) as dynamic
    ' check that screen exists
    node = screenExists(screenId)
    ' check that the node is valid
    if (node <> invalid)
        ' check if node is not visible and showScreen is true
        if not node.visible and showScreen then node.visible = true
        ' return the requested node
        return node
    else
        logging(screenId + " was not found", 1)
        return invalid
    end if
end function
function screenExists(screenId as string) as dynamic
    ' ensure screenId is valid and not an empty string
    if (not isNullOrEmpty(screenId))
        ' get the screen node
        return m.top.getScene().findNode(screenId)
    else
        logging("screenId invalid or empty", 2)
    end if
end function
function addScreen(screenName as string, screenId = "" as string, showScreen = true as boolean, hidePrevScreen = true as boolean, addToStack = true as boolean) as object
    ' check if screenId is invalid or empty
    if (isNullOrEmpty(screenId))
        ' assign the screenName to the screenId
        screenId = screenName
        logging("No ID assigned for " + screenName + " node - using " + """" + screenName + """" + " as ID", 1)
    end if
    ' check if the screenId has already been given to an existing screen node
    if (isValid(screenExists(screenId)))
        logging(screenId + "' is already assigned to another screen node. Please create a new id for this node.", 2)
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
        logging("valid screens nodes from HomeScene.xml:", 1)
        ' loop over each screen in the array and print to console
        for each screen in screenArray
            print(" -> " + screen)
        end for
    else
        logging("there are no valid screens nodes for HomeScene", 2)
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