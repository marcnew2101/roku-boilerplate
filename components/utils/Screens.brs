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
            ? screenId + " was not found. Check the id and try again. If the node does not already exist, use the setScreen() function to create it."
            return invalid
        end if
    else
        ' show a console message stating that getScreen requires a valid screenId
        ? " "
        ? "you must set a valid id (string) for screenId if you wish to locate a valid screen node."
    end if
end function
function addScreen(screenName as string, screenId = invalid as string, showScreen = true as boolean, hidePrevScreen = true as boolean, addToStack = true as boolean)
    ' check that the argument for screenName is valid and has a string length greater than zero
    if (screenName <> invalid and len(screenName) > 0)
        ' set intial duplicate id value to false
        duplicateNodeId = false
        ' check if the argument for id is valid and has a string length greater than zero
        if (screenId <> invalid and len(screenId) > 0)
            ' get the full array of child nodes from HomeScene
            screenArray = getAllScreens()
            ' check that the screen array is valid and has an item count of greater than zero
            if (screenArray <> invalid and screenArray.count() > 0)
                ' loop over each screen in the array
                for each screen in screenArray
                    ' check if the screen id is valid and matches the screenId argument
                    if (screen.id <> invalid and screen.id = screenId)
                        ' set the duplicateNodeId to true if a duplicate ID is found
                        duplicateNodeId = true
                        ' exit the for loop
                        exit for
                    end if
                end for
            end if
        end if
        ' check if the duplicateNodeId is true
        if (duplicateNodeId)
            ' show a console message stating the node ID already exists
            ? " "
            ? screenId + " is already assigned to another node. Please choose another id for this node."
        else
            ' return the created screen by calling the createScreen interface function from HomeScene.xml
            return m.top.getScene().callFunc("addNode", {"screenName": screenName, "showScreen": showScreen, "screenId": screenId, "hidePrevScreen": hidePrevScreen, "addToStack": addToStack})
        end if
    else
        ' show a console message stating that createScreen requires a valid screenName
        ? " "
        ? "you must set a valid name (string) for screenName if you wish to create a new screen node."
    end if
end function
function removeScreen(screen = invalid as dynamic, showPrevScreen = true as boolean, removeFromStack = true as boolean)
    ' check that screen is valid
    if (screen <> invalid)
        ' set initial node value
        node = invalid
        ' check if the screen is a node type
        if (type(screen) = "roSGNode")
            ' set the node value
            node = screen
        ' check if the screen is a string type
        else if (type(screen) = "String")
            ' find the node and set the return valud
            node = getScreen(screen)
        end if
        ' check if the node is valid
        if (node <> invalid)
            ' call the removeNode function on the HomeScene.xml interface
            m.top.getScene().callFunc("removeNode", {"node": node, "showPrevScreen": showPrevScreen, "removeFromStack": removeFromStack})
        end if
    end if
end function
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
    ' show a list of valid screens on HomeScene
    ? " "
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