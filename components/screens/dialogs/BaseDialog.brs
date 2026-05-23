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
    if m.titleArea = invalid then return
    if hasValue(m.titleArea.primaryTitle) then m.titleArea.primaryTitle = ""
    if hasValue(title) then m.titleArea.primaryTitle = title
end sub

sub onMessageChange(obj)
    message = obj.getData()
    if m.messageText = invalid then return
    if hasValue(m.messageText.text) then m.messageText.text = ""
    if not hasValue(message) then return
    m.messageText.text = message
    m.messageText.namedTextStyle = "bold"
    firstChild = m.messageText.getChild(0)
    if firstChild <> invalid then firstChild.font.size = 32
end sub

sub onBulletTextChange(obj)
    bullets = obj.getData()
    if m.bulletArea = invalid then return
    if m.bulletArea.bulletText.count() > 0 then m.bulletArea.bulletText = []
    if not hasValue(bullets) then return
    m.bulletArea.bulletText = bullets
    bulletColor = m.scene.palette.colors.dialogBulletTextColor
    container = m.bulletArea.getChild(0)
    if container = invalid then return
    for each node in container.getChildren(-1, 0)
        node.update({ "color": bulletColor }, true)
        node.font.size = 29
    end for
end sub

sub onButtonChange(obj)
    buttons = obj.getData()
    if m.buttonArea = invalid then return
    if m.buttonArea.getChildCount() > 0 then m.buttonArea.removeChildren(m.buttonArea.getChildren(-1, 0))
    if not hasValue(buttons) then return
    for each button in buttons
        buttonNode = createObject("roSGNode", "StdDlgButton")
        buttonNode.text = valueOr(button.label, "")
        m.buttonArea.appendChild(buttonNode)
    end for
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    if key <> Const().key.back then return false
    dialogModal = getScreen("dialogModal")
    if dialogModal = invalid or not hasValue(dialogModal.dialogInfo)
        ' BaseDialog shouldn't have focus without a dialogModal — bubble so something else can handle it
        logWarn("back key in BaseDialog with no dialogModal/dialogInfo", "BaseDialog.brs")
        return false
    end if
    if dialogModal.dialogInfo.allowBack = true then removeScreen(dialogModal)
    return true
end function