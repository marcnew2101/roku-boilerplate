sub init()
    ' set the initial visibility of the screen to false
    m.top.visible = false
    ' observe screen visibility
    m.top.observeField("visible", "screenVisible")
end sub
sub createDialogNode()
    ' check if the Roku device is running at least version 10
    if (m.global.os >= 10.0)
        ' create standard message dialog node
        m.dialogNode = CreateObject("roSGNode", "BaseDialog")
    else
        ' create legacy dialog node
        m.dialogNode = CreateObject("roSGNode", "Dialog")
    end if
    ' create id for dialog node
    m.dialogNode.id = "baseDialog"
    ' observe button selection on the dialog node
    m.dialogNode.observeField("buttonSelected", "onButtonSelected")
    ' if the parent/top node contains more than 1 node then delete the last node
    if m.top.getChildCount() > 1 then m.top.removeChildIndex(1)
    ' add the dialog node to the top parent (screen) node
    m.top.appendChild(m.dialogNode)
end sub
sub screenVisible(obj)
    visible = obj.getData()
    ' check if the screen is visible
    if (visible)
        ' set key focus to the dialog node
        m.dialogNode.setFocus(true)
    else
        ' set focus to previous node if interface on HomeScene is valid
        if m.top.getScene().focusedNode <> invalid then m.top.getScene().focusedNode.setFocus(true)
    end if
end sub
sub populateDialogBox(obj)
    m.dialogInfo = obj.getData()
    ' check that the dialogInfo object is valid and count is greater than zero
    if (m.dialogInfo <> invalid and m.dialogInfo.count() > 0)
        ' create the dialog node
        createDialogNode()
        ' check that the dialog info title is not Invalid and not an empty string
        if m.dialogInfo.title <> invalid and len(m.dialogInfo.title) > 0 then m.dialogNode.title = m.dialogInfo.title
        ' check that the dialog info message is not Invalid and not an empty string
        if m.dialogInfo.message <> invalid and len(m.dialogInfo.message) > 0 then m.dialogNode.message = m.dialogInfo.message
        ' check that the dialog info help message is not Invalid and not an empty array
        if m.dialogInfo.help <> invalid and m.dialogInfo.help.count() > 0 then m.dialogNode.bulletText = m.dialogInfo.help
        ' check that the dialog info buttons are not Invalid and not an empty array
        if m.dialogInfo.buttons <> invalid and m.dialogInfo.buttons.count() > 0 then m.dialogNode.buttons = m.dialogInfo.buttons
        ' set screen to visible
        if not m.top.visible then m.top.visible = true
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
            ' remove dialog modal screen
            removeScreen(m.top)
        end if
        ' check if button pressed is "CANCEL" or "NO"
    else if (buttonSelected = "CANCEL" or buttonSelected = "NO")
        ' remove dialog modal screen
        removeScreen(m.top)
    end if
end sub