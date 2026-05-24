sub initScreenStack()
    ' create the initial empty screen stack array
    m.screenStack = []
end sub

function addHistory(node as object, showScreen as boolean, hidePrevScreen as boolean, addToStack as boolean) as boolean
    if node = invalid then return false
    ' appendChild first so a failure leaves the stack and prev-screen visibility untouched;
    ' BaseScreen.init() already sets visible=false, so no double-visible flash
    if not m.top.appendChild(node) then return false

    if hidePrevScreen = true and hasValue(m.screenStack)
        prevNode = m.screenStack.peek()
        if prevNode <> invalid then prevNode.visible = false
    end if
    if showScreen <> invalid then node.visible = showScreen
    if addToStack = true and m.screenStack <> invalid
        m.screenStack.push(node)
    end if
    return true
end function

function removeHistory(node as object, showPrevScreen as boolean, removeFromStack as boolean) as boolean
    if node = invalid then return false
    if hasValue(m.screenStack)
        if removeFromStack = true
            ' walk from top so out-of-order removals don't leave ghost entries in the stack
            for i = m.screenStack.count() - 1 to 0 step -1
                if m.screenStack[i].isSameNode(node)
                    m.screenStack.delete(i)
                    exit for
                end if
            end for
        end if
        if m.screenStack.count() > 0 and showPrevScreen = true
            prevNode = m.screenStack.peek()
            if prevNode <> invalid
                if not prevNode.visible then prevNode.visible = true
                if prevNode.focusedNode <> invalid
                    prevNode.focusedNode.setFocus(true)
                end if
            end if
        end if
    end if

    if node.visible then node.visible = false
    return m.top.removeChild(node)
end function