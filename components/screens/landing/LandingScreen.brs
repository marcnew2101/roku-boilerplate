sub onScreenInit()
    m.labelList = m.top.findNode("landingLabelList")
    m.landingTitle = m.top.findNode("landingTitle")
    m.labelList.observeField("itemSelected", "onItemSelected")
end sub
sub onScreenVisible()
    setLandingTitle()
    populateLabelList()
    setLabelList()
    setFocus(m.labelList)
    ' Roku certification requires this beacon to indicate app finished loading
    appLoaded()
end sub
sub setLandingTitle()
    ' tr() is optional — pass plain strings if you don't need translations
    m.landingTitle.text = tr("Welcome To The Landing Screen")
    m.landingTitle.font.size = 62
    m.landingTitle.color = m.top.getScene().palette.colors.primaryTextColor
end sub
sub populateLabelList()
    ' tr() is optional — pass plain strings if you don't need translations
    listItems = [
        tr("Sign In"),
        tr("Register"),
        tr("Exit")
    ]
    parentNode = createObject("roSGNode", "ContentNode")
    for each item in listItems
        childNode = createObject("roSGNode", "ContentNode")
        childNode.title = item
        parentNode.appendChild(childNode)
    end for
    m.labelList.content = parentNode
end sub
sub setLabelList()
    ' center the label list within the UI viewport
    labelListX = (m.global.ui.width - m.labelList.boundingRect().width) / 2
    labelListY = (m.global.ui.height - m.labelList.boundingRect().height) / 2
    m.labelList.translation = [labelListX, labelListY]

    ' theme the label list using the HomeScene palette
    if m.top.getScene().selectorUri <> invalid then m.labelList.focusBitmapUri = m.top.getScene().selectorUri
    m.labelList.color = m.top.getScene().palette.colors.primaryTextColor
    m.labelList.focusedColor = m.top.getScene().palette.colors.primaryTextColor
end sub
sub onItemSelected(obj)
    itemIndex = obj.getData()
    itemSelected = m.labelList.content.getChild(itemIndex)
    if itemSelected.title = tr("Exit") then m.top.getScene().message = "exit"
end sub
' capture key events from remote control
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    keys = Const().key
    if key = keys.back
        m.top.getScene().message = "exit"
        return true
    end if
    if key = keys.up
        ? "up key pressed"
        return true
    end if
    if key = keys.down
        ? "down key pressed"
        return true
    end if
    return false
end function