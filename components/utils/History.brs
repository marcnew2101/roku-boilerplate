sub initScreenStack()
    ' create the initial empty screen stack array
    m.screenStack = []
end sub
function addHistory(node as object, showScreen as boolean, hidePrevScreen as boolean, addToStack as boolean) as boolean
    ' check that new node is valid
    if (node <> invalid)
        ' check if hidePrevScreen is both valid and true
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
function removeHistory(node as object, showPrevScreen as boolean, removeFromStack as boolean) as boolean
    if (node <> invalid)
        ' check that the screen stack array is valid and contains items
        if (m.screenStack <> invalid and m.screenStack.count() > 0)
            ' check if removeFromStack is both valid and true
            if (removeFromStack <> invalid and removeFromStack)
                ' remove the last node from the screen stack array
                if m.screenStack.peek().isSameNode(node) then m.screenStack.pop()
            end if
            ' check that the screen stack array still contains items and showPrevScreen is both valid and true
            if (m.screenStack.count() > 0 and showPrevScreen <> invalid and showPrevScreen)
                ' set prevNode to last node in array
                prevNode = m.screenStack.peek()
                ' check if prevNode is valid
                if (prevNode <> invalid)
                    ' get the last node in the screen stack array and check for visibility before setting visibility to true
                    if not prevNode.visible then prevNode.visible = true
                    ' check if the previous node's focusedNode field is valid then set focus to it
                    if prevNode.focusedNode <> invalid then prevNode.focusedNode.setFocus(true)
                end if
            end if
        end if
        ' set the node visibility to false
        if node.visible then node.visible = false
        ' remove the node as a child of HomeScene and return the result
        return m.top.removeChild(node)
    end if
end function
sub getHistory()
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