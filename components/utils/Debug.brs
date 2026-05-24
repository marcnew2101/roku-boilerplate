sub showAllScreens()
    screenArray = scene().getChildren(-1, 0)
    if screenArray = invalid or screenArray.count() = 0
        logDebug("no valid screens/nodes in HomeScene", "Debug.brs")
        return
    end if

    logDebug("valid screens/nodes in HomeScene:", "Debug.brs")
    for each screen in screenArray
        logDebug(" -> " + screen.subType(), "Debug.brs")
    end for
end sub

sub getHistory()
    if not hasValue(m.screenStack)
        logDebug("screen stack is empty", "Debug.brs")
        return
    end if

    logDebug("screen stack contents:", "Debug.brs")
    for each node in m.screenStack
        logDebug(" -> " + node.subType(), "Debug.brs")
    end for
end sub

sub showFocus()
    if scene() = invalid
        logDebug("no scene available", "Debug.brs")
        return
    end if

    leaf = scene().focusedChild
    if leaf = invalid
        logDebug("no node has focus", "Debug.brs")
        return
    end if

    ' walk parent links up from the focused leaf, then print in root-to-leaf order
    chain = []
    node = leaf
    while node <> invalid
        chain.push(node)
        node = node.getParent()
    end while

    logDebug("focus chain (root to leaf):", "Debug.brs")
    for i = chain.count() - 1 to 0 step -1
        logDebug(" -> " + chain[i].subType(), "Debug.brs")
    end for
end sub

sub showTheme()
    t = theme()
    if t.colors = invalid
        logDebug("no palette colors set", "Debug.brs")
        return
    end if

    logDebug("theme.colors:", "Debug.brs")
    for each key in t.colors.keys()
        logDebug("  " + key + " = " + t.colors[key], "Debug.brs")
    end for

    logDebug("scene-level theme fields:", "Debug.brs")
    logDebug("  backgroundColor = " + valueOr(t.backgroundColor, "(unset)"), "Debug.brs")
    logDebug("  backgroundUri = " + valueOr(t.backgroundUri, "(unset)"), "Debug.brs")
    logDebug("  selectorUri = " + valueOr(t.selectorUri, "(unset)"), "Debug.brs")
end sub
