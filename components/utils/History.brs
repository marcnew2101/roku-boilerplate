sub initScreenStack()
    ' create the initial empty screen stack array
    m.screenStack = []
end sub
function addHistory(node as object, showScreen as boolean, hidePrevScreen as boolean, addToStack as boolean) as boolean
    if node = invalid then return false
    if hidePrevScreen <> invalid and hidePrevScreen and m.screenStack <> invalid and m.screenStack.count() > 0
        prevNode = m.screenStack.peek()
        if prevNode <> invalid then prevNode.visible = false
    end if
    if showScreen <> invalid then node.visible = showScreen
    if addToStack <> invalid and addToStack and m.screenStack <> invalid
        m.screenStack.push(node)
    end if
    return m.top.appendChild(node)
end function
function removeHistory(node as object, showPrevScreen as boolean, removeFromStack as boolean) as boolean
    if node = invalid then return false
    if m.screenStack <> invalid and m.screenStack.count() > 0
        if removeFromStack <> invalid and removeFromStack
            if m.screenStack.peek().isSameNode(node) then m.screenStack.pop()
        end if
        if m.screenStack.count() > 0 and showPrevScreen <> invalid and showPrevScreen
            prevNode = m.screenStack.peek()
            if prevNode <> invalid
                if not prevNode.visible then prevNode.visible = true
                if prevNode.focusedNode <> invalid then prevNode.focusedNode.setFocus(true)
            end if
        end if
    end if
    if node.visible then node.visible = false
    return m.top.removeChild(node)
end function
sub getHistory()
    if m.screenStack = invalid or m.screenStack.count() = 0
        logDebug("screen stack is empty", "History.brs")
        return
    end if
    logDebug("screen stack contents:", "History.brs")
    for each node in m.screenStack
        logDebug(" -> " + node.subType() + " (id=" + node.id + ")", "History.brs")
    end for
end sub