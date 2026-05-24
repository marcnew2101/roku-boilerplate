sub init()
    baseScreenInit()
end sub

sub createDialogNode(title = "" as string, message = "" as string, help = [] as object, buttons = [] as object)
    dialogNode = CreateObject("roSGNode", "BaseDialog")
    dialogNode.title = title
    dialogNode.message = message
    dialogNode.helpText = help
    dialogNode.buttons = buttons
    dialogNode.observeField("buttonSelected", "onButtonSelected")
    m.top.appendChild(dialogNode)
    setFocus(dialogNode, false)
    ' Roku certification requires this beacon when a modal appears before launchComplete
    dialogInit()
end sub

sub populateDialogBox(obj)
    config = obj.getData()
    if not hasValue(config) then return
    title = valueOr(config.title, "")
    message = valueOr(config.message, "")
    help = valueOr(config.help, [])
    buttons = valueOr(config.buttons, [])
    createDialogNode(title, message, help, buttons)
end sub

sub onButtonSelected(obj)
    buttonIndex = obj.getData()
    firingNode = m.top.findNode(obj.getNode())
    if firingNode = invalid
        logWarn("onButtonSelected: firing node not found (id=" + obj.getNode() + ")", "DialogModal.brs")
        return
    end if
    if buttonIndex < 0 or buttonIndex >= firingNode.buttons.count()
        logWarn("onButtonSelected: index " + buttonIndex.toStr() + " out of range", "DialogModal.brs")
        return
    end if
    btn = firingNode.buttons[buttonIndex]
    if hasValue(btn.onPress) and btn.onPress.node <> invalid and hasValue(btn.onPress.func)
        btn.onPress.node.callFunc(btn.onPress.func, { label: btn.label, index: buttonIndex })
    end if
    if btn.exitApp = true
        m.scene.exitApp = true
    else
        dismissTop()
    end if
end sub

sub dismissTop()
    if m.top.getChildCount() > 1
        m.top.removeChildIndex(m.top.getChildCount() - 1)
        setFocus(m.top.getChild(m.top.getChildCount() - 1), false)
    else
        removeScreen(m.top)
        dialogComplete()
    end if
end sub
