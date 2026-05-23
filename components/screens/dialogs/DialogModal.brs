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
    if m.dialogInfo = invalid or m.dialogInfo.count() = 0 then return
    if m.dialogInfo.title <> invalid and len(m.dialogInfo.title) > 0
        title = m.dialogInfo.title
    else
        title = ""
    end if
    if m.dialogInfo.message <> invalid and len(m.dialogInfo.message) > 0
        message = m.dialogInfo.message
    else
        message = ""
    end if
    if m.dialogInfo.help <> invalid and m.dialogInfo.help.count() > 0
        help = m.dialogInfo.help
    else
        help = []
    end if
    if m.dialogInfo.buttons <> invalid and m.dialogInfo.buttons.count() > 0
        buttons = m.dialogInfo.buttons
    else
        buttons = []
    end if
    createDialogNode(title, message, help, buttons)
end sub
sub onButtonSelected(obj)
    buttonIndex = obj.getData()
    buttonSelected = m.dialogNode.buttons[buttonIndex]
    button = Const().button
    if buttonSelected = button.okay or buttonSelected = button.yes
        if m.dialogInfo.exitApp <> invalid and m.dialogInfo.exitApp
            m.top.getScene().exitApp = true
        else
            removeBaseDialog()
        end if
    else if buttonSelected = button.cancel or buttonSelected = button.no
        removeBaseDialog()
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