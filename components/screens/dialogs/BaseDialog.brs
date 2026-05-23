sub init()
    if m.top.id = invalid or len(m.top.id) = 0 then m.top.id = "baseDialog"
    m.titlearea = m.top.findNode("titleArea")
    m.contentarea = m.top.findNode("contentArea")
    m.messagetext = m.top.findNode("messageText")
    m.bulletarea = m.top.findNode("bulletArea")
    m.buttonarea = m.top.findNode("buttonArea")
end sub
sub onTitleChange(obj)
    title = obj.getData()
    if m.titlearea <> invalid and len(m.titlearea.primaryTitle) > 0
        m.titlearea.primaryTitle = ""
    end if
    if title <> invalid and len(title) > 0 then m.titlearea.primaryTitle = title
end sub
sub onMessageChange(obj)
    message = obj.getData()
    if m.messagetext <> invalid and len(m.messagetext.text) > 0 then m.messagetext.text = ""
    if message = invalid or len(message) = 0 then return
    m.messagetext.text = message
    m.messagetext.namedTextStyle = "bold"
    m.messagetext.getChild(0).font.size = 32
end sub
sub onBulletTextChange(obj)
    bullets = obj.getData()
    if m.bulletarea <> invalid and m.bulletarea.bulletText.count() > 0
        m.bulletarea.bulletText = []
    end if
    if bullets = invalid or bullets.count() = 0 then return
    m.bulletarea.bulletText = bullets
    for each node in m.bulletarea.getChild(0).getChildren(-1, 0)
        node.update({ "color": m.top.getScene().palette.colors.dialogBulletTextColor }, true)
        node.font.size = 29
    end for
end sub
sub onButtonChange(obj)
    buttons = obj.getData()
    if m.buttonarea <> invalid and m.buttonarea.getChildCount() > 0
        m.buttonarea.removeChildren(m.buttonarea.getChildren(-1, 0))
    end if
    if buttons = invalid or buttons.count() = 0 then return
    for each button in buttons
        buttonNode = createObject("roSGNode", "StdDlgButton")
        buttonNode.text = button
        m.buttonarea.appendChild(buttonNode)
    end for
end sub
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    if key <> Const().key.back then return false
    dialogModal = getScreen("dialogModal")
    if dialogModal = invalid or dialogModal.dialogInfo = invalid or dialogModal.dialogInfo.count() = 0
        return true
    end if
    if dialogModal.dialogInfo.allowBack <> invalid and dialogModal.dialogInfo.allowBack
        removeScreen(dialogModal)
    end if
    return true
end function