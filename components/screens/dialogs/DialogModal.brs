sub init()
    ' set the initial visibility of the screen to false
    m.top.visible = false
end sub
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
    ' check if the dialogInfo object is valid and count is greater than zero
    if (m.dialogInfo <> invalid and m.dialogInfo.count() > 0)
        ' inspect the dialog info title
        if m.dialogInfo.title <> invalid and len(m.dialogInfo.title) > 0 then title = m.dialogInfo.title else title = ""
        ' inspect the dialog info message
        if m.dialogInfo.message <> invalid and len(m.dialogInfo.message) > 0 then message = m.dialogInfo.message else message = ""
        ' inspect the dialog info help message
        if m.dialogInfo.help <> invalid and m.dialogInfo.help.count() > 0 then help = m.dialogInfo.bulletText else help = []
        ' inspect the dialog info buttons
        if m.dialogInfo.buttons <> invalid and m.dialogInfo.buttons.count() > 0 then buttons = m.dialogInfo.buttons else buttons = []
        ' create the dialog node
        createDialogNode(title, message, help, buttons)
    end if
end sub
sub onButtonSelected(obj)
    ' get button index
    buttonIndex = obj.getData()
    ' get button title
    buttonSelected = m.dialogNode.buttons[buttonIndex]
    ' check if button pressed is "OKAY" or "YES"
    if (buttonSelected = "OKAY" or buttonSelected = "YES")
        ' check that closeApp is not invalid and set to true
        if (m.dialogInfo.exitApp <> invalid and m.dialogInfo.exitApp)
            ' immediately close the app
            m.top.getScene().exitApp = true
        else
            removeBaseDialog()
        end if
        ' check if button pressed is "CANCEL" or "NO"
    else if (buttonSelected = "CANCEL" or buttonSelected = "NO")
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