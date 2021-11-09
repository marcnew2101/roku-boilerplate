sub init()
    ' create a dialog node
    createDialogNode()

    ' observe screen visibility
    m.top.observeField("visible", "screenVisible")

    ' set the inital value to false for using the legacy dialog window (before RokuOS 10.0)
    m.legacyDialog = false
end sub

sub createDialogNode()
    ' check if the Roku device is running at least version 10
    if (m.global.os >= 10.0)
        ' create the standard message dialog node
        m.dialogNode = CreateObject("roSGNode", "StandardMessageDialog")
        m.dialogNode.observeField("buttonSelected", "onButtonSelected")
    else
        ' set legacy node to true
        m.legacyDialog = true
        ' create the legacy dialog node
        m.dialogNode = CreateObject("roSGNode", "Dialog")
    end if

    ' OPTIONAL customize the appearance of text/background colors
    customizeDialogNode(m.dialogNode)

    ' add the dialog node to the top parent (screen) node
    m.top.appendChild(m.dialogNode)
end sub

sub screenVisible(obj)
    visible = obj.getData()
    if (visible)
        ' set key focus to the dialog node
        m.dialogNode.setFocus(true)
    end if
end sub

sub populateDialogBox(obj)
    dialogInfo = obj.getData()

    if (m.legacyDialog)
        ' TODO define legacy dialog node
    else
        m.dialogNode.title = dialogInfo.title
        m.dialogNode.message = [dialogInfo.message]
        m.dialogNode.buttons = ["OKAY"]

        if (dialogInfo.help <> Invalid AND len(dialogInfo.help) > 0)
            m.dialogNode.bulletText = [dialogInfo.help]
        end if
    end if

    m.top.visible = true
end sub

sub onButtonSelected(obj)
    buttonIndex = obj.getData()
    buttonSelected = m.dialogNode.buttons[buttonIndex]
    ? buttonSelected
    ' TODO define button presses
end sub

sub customizeDialogNode(dialogNode)
    ' TODO create variables for dialog customization
end sub