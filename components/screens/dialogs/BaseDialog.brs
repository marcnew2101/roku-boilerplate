sub init()
    ' cache the root Scene; util scripts use m.scene instead of m.top.getScene()
    m.scene = m.top.getScene()
    if not hasValue(m.top.id) then m.top.id = "baseDialog"
    m.titleArea = m.top.findNode("titleArea")
    m.messageText = m.top.findNode("messageText")
    m.bulletArea = m.top.findNode("bulletArea")
    m.buttonArea = m.top.findNode("buttonArea")
end sub

sub onTitleChange(obj)
    title = obj.getData()
    if m.titleArea <> invalid and hasValue(m.titleArea.primaryTitle)
        m.titleArea.primaryTitle = ""
    end if
    if hasValue(title) then m.titleArea.primaryTitle = title
end sub

sub onMessageChange(obj)
    message = obj.getData()
    if m.messageText <> invalid and hasValue(m.messageText.text) then m.messageText.text = ""
    if not hasValue(message) then return
    m.messageText.text = message
    m.messageText.namedTextStyle = "bold"
    m.messageText.getChild(0).font.size = 32
end sub

sub onBulletTextChange(obj)
    bullets = obj.getData()
    if m.bulletArea <> invalid and m.bulletArea.bulletText.count() > 0
        m.bulletArea.bulletText = []
    end if
    if not hasValue(bullets) then return
    m.bulletArea.bulletText = bullets
    bulletColor = m.scene.palette.colors.dialogBulletTextColor
    for each node in m.bulletArea.getChild(0).getChildren(-1, 0)
        node.update({ "color": bulletColor }, true)
        node.font.size = 29
    end for
end sub

sub onButtonChange(obj)
    buttons = obj.getData()
    if m.buttonArea <> invalid and m.buttonArea.getChildCount() > 0
        m.buttonArea.removeChildren(m.buttonArea.getChildren(-1, 0))
    end if
    if not hasValue(buttons) then return
    for each button in buttons
        buttonNode = createObject("roSGNode", "StdDlgButton")
        buttonNode.text = button
        m.buttonArea.appendChild(buttonNode)
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