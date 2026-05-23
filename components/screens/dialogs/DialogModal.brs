sub createDialogNode(title = "" as string, message = "" as string, help = [] as object, buttons = [] as object)
    ' create message dialog node
    m.dialogNode = CreateObject("roSGNode", "BaseDialog")
    ' set dialog title
    m.dialogNode.title = title
    ' set dialog message
    m.dialogNode.message = message
    ' set dialog help bullets
    m.dialogNode.bulletText = help
    ' set dialog buttons
    m.dialogNode.buttons = buttons
    ' observe button selection on the dialog node
    m.dialogNode.observeField("buttonSelected", "onButtonSelected")
    ' add the dialog node to the top parent node
    m.top.appendChild(m.dialogNode)
    ' set focus to the dialog node
    setFocus(m.dialogNode, false)
    ' send signal beacon per Roku certification requirements
    dialogInit()
end sub

sub populateDialogBox(obj)
    m.dialogInfo = obj.getData()
    if not hasValue(m.dialogInfo) then return
    title = valueOr(m.dialogInfo.title, "")
    message = valueOr(m.dialogInfo.message, "")
    help = valueOr(m.dialogInfo.help, [])
    buttons = valueOr(m.dialogInfo.buttons, [])
    createDialogNode(title, message, help, buttons)
end sub

sub onButtonSelected(obj)
    buttonIndex = obj.getData()
    buttonSelected = m.dialogNode.buttons[buttonIndex]
    button = Const().button
    if buttonSelected = button.okay or buttonSelected = button.yes
        if m.dialogInfo.exitApp = true
            m.scene.exitApp = true
        else
            removeBaseDialog()
        end if
    else if buttonSelected = button.cancel or buttonSelected = button.no
        removeBaseDialog()
    else
        ' unknown label means the messages.json entry doesn't match Const().button —
        ' dialog stays open so the dev sees this warning without losing user state
        logWarn("unrecognized button '" + valueOr(buttonSelected, "<invalid>") + "' — must match Const().button", "DialogModal.brs")
    end if
end sub

sub removeBaseDialog()
    ' check parent for child nodes greater than 1
    if m.top.getChildCount() > 1
        ' remove the parent's last child node
        m.top.removeChildIndex(m.top.getChildCount() - 1)
        ' set focus to next child node
        setFocus(m.top.getChild(m.top.getChildCount() - 1), false)
    else
        ' remove dialog modal screen
        removeScreen(m.top)
        ' send signal beacon per Roku certification requirements
        dialogComplete()
    end if
end sub