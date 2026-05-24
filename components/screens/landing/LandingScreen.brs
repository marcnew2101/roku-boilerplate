sub init()
    baseScreenInit()

    m.landingTitle = m.top.findNode("landingTitle")
    m.labelList = m.top.findNode("landingLabelList")
    m.contentGroup = m.top.findNode("landingContent")

    m.labelList.observeField("itemSelected", "onItemSelected")

    setupLandingTitle()
    setupLabelList()
end sub

sub onScreenVisible()
    updateLayout()
    setFocus(m.labelList)
    appLoaded()
end sub

sub setupLandingTitle()
    ' tr() is optional — pass plain strings if you don't need translations
    m.landingTitle.text = tr("Welcome To The Landing Screen")
    m.landingTitle.font.size = 62
    m.landingTitle.color = theme().colors.primaryTextColor
end sub

sub setupLabelList()
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

    if theme().selectorUri <> invalid
        m.labelList.focusBitmapUri = theme().selectorUri
    end if
    m.labelList.color = theme().colors.primaryTextColor
    m.labelList.focusedColor = theme().colors.primaryTextColor
end sub

sub updateLayout()
    ' boundingRect returns bounds in parent coords with the node's current translation baked in,
    ' so we shift by the delta needed to move the rendered center onto the scene's design center
    rect = m.contentGroup.boundingRect()
    if rect.width = 0 or rect.height = 0 then return

    res = m.scene.currentDesignResolution
    deltaX = (res.width / 2) - (rect.x + rect.width / 2)
    deltaY = (res.height / 2) - (rect.y + rect.height / 2)
    if abs(deltaX) < 1 and abs(deltaY) < 1 then return

    current = m.contentGroup.translation
    m.contentGroup.translation = [current[0] + deltaX, current[1] + deltaY]
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
