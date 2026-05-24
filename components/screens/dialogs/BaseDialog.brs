sub init()
    ' cache the root Scene; util scripts use m.scene instead of m.top.getScene()
    m.scene = m.top.getScene()
    if not hasValue(m.top.id) then m.top.id = "baseDialog"
    m.titleArea = m.top.findNode("titleArea")
    m.messageText = m.top.findNode("messageText")
    m.helpArea = m.top.findNode("helpArea")
    m.buttonArea = m.top.findNode("buttonArea")
end sub

sub onTitleChange(obj)
    title = obj.getData()
    if m.titleArea = invalid then return
    if hasValue(title) then m.titleArea.primaryTitle = title
end sub

sub onMessageChange(obj)
    message = obj.getData()
    if m.messageText = invalid then return
    if not hasValue(message) then return
    m.messageText.text = message
    m.messageText.namedTextStyle = Const().dialog.messageTextStyle
    firstChild = m.messageText.getChild(0)
    if firstChild <> invalid then firstChild.font.size = Const().dialog.messageFontSize
end sub

sub onHelpTextChange(obj)
    items = obj.getData()
    if m.helpArea = invalid then return
    if not hasValue(items) then return
    m.helpArea.bulletText = items
    helpColor = m.scene.palette.colors.dialogHelpTextColor
    container = m.helpArea.getChild(0)
    if container = invalid then return
    for each node in container.getChildren(-1, 0)
        node.update({ "color": helpColor }, true)
        node.font.size = Const().dialog.helpFontSize
    end for
end sub

sub onButtonChange(obj)
    buttons = obj.getData()
    if m.buttonArea = invalid then return
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
    ' route through DialogModal.dismissTop so stacked dialogs pop one-at-a-time
    ' (symmetric with button-press teardown). removeScreen would nuke the whole stack.
    if dialogModal.dialogInfo.allowBack = true then dialogModal.callFunc("dismissTop")
    return true
end function