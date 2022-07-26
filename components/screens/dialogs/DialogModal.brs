sub init()
    ' set the initial visibility of the screen to false
    m.top.visible = false
    ' create the initial dialog node
    createDialogNode()
    ' observe screen visibility
    m.top.observeField("visible", "screenVisible")
end sub

sub createDialogNode()
    ' check if the Roku device is running at least version 10
    if (m.global.os >= 10.0)
        ' create standard message dialog node
        m.dialogNode = CreateObject("roSGNode", "BaseDialog")
        m.legacyNode = false
    else
        ' create legacy dialog node
        m.dialogNode = CreateObject("roSGNode", "Dialog")
    end if

    ' observe button selection on the dialog node
    m.dialogNode.observeField("buttonSelected", "onButtonSelected")

    ' add the dialog node to the top parent (screen) node
    m.top.appendChild(m.dialogNode)
end sub

' screen visibility observer
sub screenVisible(obj)
    visible = obj.getData()
    ' check if the screen is visible
    if (visible)
        ' set key focus to the dialog node
        m.dialogNode.setFocus(true)
    else

    end if
end sub

sub populateDialogBox(obj)
    m.dialogInfo = obj.getData()
    ' check that the dialog info title is not Invalid and not an empty string
    if m.dialogInfo.title <> Invalid AND len(m.dialogInfo.title) > 0 then m.dialogNode.title = m.dialogInfo.title
    ' check that the dialog info message is not Invalid and not an empty string
    if m.dialogInfo.message <> Invalid AND len(m.dialogInfo.message) > 0 then m.dialogNode.message = m.dialogInfo.message
    ' check that the dialog info help message is not Invalid and not an empty array
    if m.dialogInfo.help <> Invalid AND m.dialogInfo.help.count() > 0 then m.dialogNode.bulletText = m.dialogInfo.help
    ' check that the dialog info buttons are not Invalid and not an empty array
    if m.dialogInfo.buttons <> Invalid AND m.dialogInfo.buttons.count() > 0 then m.dialogNode.buttons = m.dialogInfo.buttons
    ' set screen to visible
    m.top.visible = true
end sub

sub onButtonSelected(obj)
    ' get button index
    buttonIndex = obj.getData()
    ' get button title
    buttonSelected = m.dialogNode.buttons[buttonIndex]
    ' check if button pressed is "OKAY" button
    if (buttonSelected = "OKAY")
        ' check that closeApp is not invalid and set to true
        if (m.dialogInfo.exitApp <> Invalid AND m.dialogInfo.exitApp)
            ' immediately close the app
            m.top.getScene().exitApp = true
        else
            ' remove visibility of the dialog box
            m.top.visible = false
        end if
    else if (buttonSelected = "CANCEL")
        ' remove visibility of the dialog box
        m.top.visible = false
    end if
end sub