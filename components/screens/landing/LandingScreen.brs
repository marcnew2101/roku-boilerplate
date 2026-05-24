sub init()
    baseScreenInit()
    m.labelList = m.top.findNode("landingLabelList")
    m.landingTitle = m.top.findNode("landingTitle")
    if m.labelList = invalid or m.landingTitle = invalid
        logError("landing screen nodes not found in XML", "LandingScreen.brs")
        return
    end if
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
    m.landingTitle.color = theme().colors.primaryTextColor
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
    if theme().selectorUri <> invalid
        m.labelList.focusBitmapUri = theme().selectorUri
    end if
    m.labelList.color = theme().colors.primaryTextColor
    m.labelList.focusedColor = theme().colors.primaryTextColor
end sub

sub onItemSelected(obj)
    itemIndex = obj.getData()
    itemSelected = m.labelList.content.getChild(itemIndex)
    if itemSelected.title = tr("Exit")
        showMessage("exit")
    end if
end sub

' capture key events from remote control
function onKeyEvent(key as string, press as boolean) as boolean
    if not press then return false
    keys = Const().key
    if key = keys.back
        showMessage("exit")
        return true
    end if
    if key = keys.up
        logDebug("up key pressed", "LandingScreen.brs")
        return true
    end if
    if key = keys.down
        logDebug("down key pressed", "LandingScreen.brs")
        return true
    end if
    return false
end function