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
    dialog = topDialog()
    if dialog = invalid
        logWarn("onButtonSelected: no dialog child to receive event", "DialogModal.brs")
        return
    end if
    buttonIndex = obj.getData()
    if buttonIndex < 0 or buttonIndex >= dialog.buttons.count()
        logWarn("onButtonSelected: index " + buttonIndex.toStr() + " out of range", "DialogModal.brs")
        return
    end if
    btn = dialog.buttons[buttonIndex]
    invokeOnPress(btn, buttonIndex)
    if btn.exitApp = true
        m.scene.exitApp = true
    else
        dismissTop()
    end if
end sub

sub dismissTop()
    if m.top.getChildCount() > 1
        m.top.removeChildIndex(m.top.getChildCount() - 1)
        setFocus(topDialog(), false)
    else
        removeScreen(m.top)
        dialogComplete()
    end if
end sub

function topDialog() as object
    return m.top.getChild(m.top.getChildCount() - 1)
end function

sub invokeOnPress(btn as object, buttonIndex as integer)
    if not hasValue(btn.onPress) then return
    if btn.onPress.node = invalid then return
    if not hasValue(btn.onPress.func) then return

    btn.onPress.node.callFunc(btn.onPress.func, { label: btn.label, index: buttonIndex })
end sub
