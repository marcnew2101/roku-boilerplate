sub initScreenStack()
    ' create the initial empty screen stack array
    m.screenStack = []
end sub
function addScreen(node as object, showScreen as boolean, hidePrevScreen as boolean, addToStack as boolean) as boolean
    ' check that new node is valid
    if (node <> invalid)
        ' check if hide previous screen is both valid and true
        if (hidePrevScreen <> invalid and hidePrevScreen)
            ' check that the screen stack array is valid and contains items
            if (m.screenStack <> invalid and m.screenStack.count() > 0)
                ' get the last item in the screen stack array
                prevNode = m.screenStack.peek()
                ' check that the previous node is valid and hide it
                if prevNode <> invalid then prevNode.visible = false
            end if
        end if
        ' check that showScreen is valid and set the new node visibility
        if showScreen <> invalid then node.visible = showScreen
        ' check if addToStack is both valid and true and that screen stack array is valid before pushing node to the end of the screen stack array
        if addToStack <> invalid and addToStack and m.screenStack <> invalid then m.screenStack.push(node)
        ' add the new node to the end of the child nodes on HomeScene and return the result
        return m.top.appendChild(node)
    end if
end function
function removeScreen(node as object, removeFromStack as boolean) as boolean
    if (node <> invalid)
        if (removeFromStack <> invalid and removeFromStack)
            if (m.screenStack <> invalid and m.screenStack.peek() <> invalid and m.screenStack.peek().isSameNode(node))
                ' remove the last node from the screen stack array
                m.screenStack.pop()
            end if
        end if
        ' set the node visibility to false
        if node.visible then node.visible = false
        ' remove the node as a child of HomeScene and return the result
        return m.top.removeChild(node)
    end if
end function
sub showAllHistory()
    ' check that the screen stack array is valid and contains items
    if (m.screenStack <> invalid and m.screenStack.count() > 0)
        ' show a console message containing the array items
        ? m.screenStack
    else
        ' show a console message stating the history is empty
        ? " "
        ? "there are no history items"
    end if
end sub