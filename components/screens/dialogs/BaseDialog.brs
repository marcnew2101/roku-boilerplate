sub init()
    if not hasValue(m.top.id) then m.top.id = "baseDialog"
    m.titlearea = m.top.findNode("titleArea")
    m.messagetext = m.top.findNode("messageText")
    m.bulletarea = m.top.findNode("bulletArea")
    m.buttonarea = m.top.findNode("buttonArea")
end sub
sub onTitleChange(obj)
    title = obj.getData()
    if m.titlearea <> invalid and hasValue(m.titlearea.primaryTitle)
        m.titlearea.primaryTitle = ""
    end if
    if hasValue(title) then m.titlearea.primaryTitle = title
end sub
sub onMessageChange(obj)
    message = obj.getData()
    if m.messagetext <> invalid and hasValue(m.messagetext.text) then m.messagetext.text = ""
    if not hasValue(message) then return
    m.messagetext.text = message
    m.messagetext.namedTextStyle = "bold"
    m.messagetext.getChild(0).font.size = 32
end sub
sub onBulletTextChange(obj)
    bullets = obj.getData()
    if m.bulletarea <> invalid and m.bulletarea.bulletText.count() > 0
        m.bulletarea.bulletText = []
    end if
    if not hasValue(bullets) then return
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
    if not hasValue(buttons) then return
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
    if dialogModal = invalid or not hasValue(dialogModal.dialogInfo) then return true
    if dialogModal.dialogInfo.allowBack = true then removeScreen(dialogModal)
    return true
end function