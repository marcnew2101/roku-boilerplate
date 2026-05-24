sub initScreenStack()
    ' create the initial empty screen stack array
    m.screenStack = []
end sub

function addToStack(params as object) as object
    if not hasValue(params) then return invalid
    if not hasValue(params.screenName) then return invalid
    node = createObject("roSGNode", params.screenName)
    if node = invalid then return invalid
    ' appendChild first so a failure leaves the stack and prev-screen visibility untouched;
    ' BaseScreen.init() already sets visible=false, so no double-visible flash
    if not m.top.appendChild(node)
        logError("error adding " + params.screenName + " to HomeScene", "History.brs")
        return invalid
    end if

    if params.hidePrevScreen = true and hasValue(m.screenStack)
        prevNode = m.screenStack.peek()
        if prevNode <> invalid then prevNode.visible = false
    end if
    if params.showScreen <> invalid then node.visible = params.showScreen
    if params.trackInHistory = true and m.screenStack <> invalid
        m.screenStack.push(node)
    end if

    node.setFocus(true)
    return node
end function

function removeFromStack(params as object) as boolean
    if not hasValue(params) then return false
    node = params.node
    if node = invalid then return false

    if hasValue(m.screenStack)
        if params.untrackHistory = true
            ' walk from top so out-of-order removals don't leave ghost entries in the stack
            for i = m.screenStack.count() - 1 to 0 step -1
                if m.screenStack[i].isSameNode(node)
                    m.screenStack.delete(i)
                    exit for
                end if
            end for
        end if
        if m.screenStack.count() > 0 and params.showPrevScreen = true
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
    if not m.top.removeChild(node)
        logError("error removing screen from HomeScene", "History.brs")
        return false
    end if
    return true
end function
