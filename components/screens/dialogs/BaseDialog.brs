sub init()
    ' check if the node ID is invalid or string length of node ID is zero
    if m.top.id = invalid or len(m.top.id) = 0 then m.top.id = "baseDialog"
    m.titlearea = m.top.findNode("titleArea")
    m.contentarea = m.top.findNode("contentArea")
    m.messagetext = m.top.findNode("messageText")
    m.bulletarea = m.top.findNode("bulletArea")
    m.buttonarea = m.top.findNode("buttonArea")
end sub
sub onTitleChange(obj)
    title = obj.getData()
    ' check that the existing titla area text is not invalid and is not an empty string
    if (m.titlearea <> invalid and len(m.titlearea.primaryTitle) > 0)
        ' reset the title area text
        m.titlearea.primaryTitle = ""
    end if
    ' check that the new title is not invalid and is not an empty string
    if (title <> invalid and len(title) > 0)
        ' set the title
        m.titlearea.primaryTitle = title
    end if
end sub
sub onMessageChange(obj)
    message = obj.getData()
    ' check that the existing message text is not invalid and is not an empty string
    if (m.messagetext <> invalid and len(m.messagetext.text) > 0)
        ' reset the message text
        m.messagetext.text = ""
    end if
    ' check that the new message is not invalid and is not an empty string
    if (message <> invalid and len(message) > 0)
        ' set the  message
        m.messagetext.text = message
        'set the message type
        m.messagetext.namedTextStyle = "bold"
        ' set the message text size
        m.messagetext.getChild(0).font.size = 32
    end if
end sub
sub onBulletTextChange(obj)
    bullets = obj.getData()
    ' check that the existing bullet text array is not invalid and is not an empty array
    if (m.bulletarea <> invalid and m.bulletarea.bulletText.count() > 0)
        ' reset the bullet text array
        m.bulletarea.bulletText = []
    end if
    ' check that the new bullet array is not invalid and is not an empty array
    if (bullets <> invalid and bullets.count() > 0)
        ' set the bullet text
        m.bulletarea.bulletText = bullets
        ' loop over each node inside bullet area
        for each node in m.bulletarea.getChild(0).getChildren(-1, 0)
            ' set the text color
            node.update({ "color": m.top.getScene().palette.colors.dialogBulletTextColor }, true)
            ' set the text size
            node.font.size = 29
        end for
    end if
end sub
sub onButtonChange(obj)
    buttons = obj.getData()
    ' check that the existing button node is not invalid and is not an empty node array
    if (m.buttonarea <> invalid and m.buttonarea.getChildCount() > 0)
        ' get all child nodes from inside the button area node
        childNodes = m.buttonarea.getChildren(-1, 0)
        ' remove all child nodes from inside the button area node
        m.buttonarea.removeChildren(childNodes)
        ' reset the button node array
        m.bulletarea.bulletText = []
    end if
    ' check that the new button array is not invalid and is not an empty array
    if (buttons <> invalid and buttons.count() > 0)
        ' loop over each new button
        for each button in buttons
            ' create a button node
            buttonNode = createObject("roSGNode", "StdDlgButton")
            ' set the button text
            buttonNode.text = button
            ' add the new button node to the button area node
            m.buttonarea.appendChild(buttonNode)
        end for
    end if
end sub
function onKeyEvent(key as string, press as boolean) as boolean
    if (press)
        if (key = "back")
            ' get the dialog modal screen
            dialogModal = getScreen("dialogModal")
            ' check that the dialog modal is valid and contains the dialog info object and they count is greater than zero
            if (dialogModal <> invalid and dialogModal.dialogInfo <> invalid and dialogModal.dialogInfo.count() > 0)
                ' check if the dialog info object contains a key for allowBack and that it is set to true
                if (dialogModal.dialogInfo.allowBack <> invalid and dialogModal.dialogInfo.allowBack)
                    ' remove dialog modal node
                    deleteScreen(dialogModal)
                end if
            end if
            return true
        end if
    end if
    return false
end function