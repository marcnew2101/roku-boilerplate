sub init()
    ' set the initial visibility of the screen to false
    m.top.visible = false
    ' ### node identifiers ###
    ' identify the label list
    m.labelList = m.top.findNode("landingLabelList")
    ' identify the title label
    m.landingTitle = m.top.findNode("landingTitle")
    ' ### node observers ###
    ' observe screen visibility
    m.top.observeField("visible", "screenVisible")
    ' observe button presses on the label list
    m.labelList.observeField("itemSelected", "onItemSelected")
end sub
sub screenVisible(obj)
    visible = obj.getData()
    if (visible)
        ' set text and theme of landing title
        setLandingTitle()
        ' populate the label list with content
        populateLabelList()
        ' set translation and theme of label list
        arrangeLabelList()
        ' set key focus to the label list
        setFocus(m.labelList)
        ' send signal beacon per Roku certification requirements
        appLoaded()
    end if
end sub
sub setLandingTitle()
    ' set the text string for the title label - tr() is optional for translating the string to another language
    m.landingTitle.text = tr("Welcome To The Landing Screen")
    ' set the font size for the title label
    m.landingTitle.font.size = 62
    ' set the label color using the palette from the home scene node
    m.landingTitle.color = m.top.getScene().palette.colors.primaryTextColor
end sub
sub populateLabelList(menuNode = initMenuContent(m.top.subType()) as object)
    m.labelList.content = menuNode
end sub
sub arrangeLabelList()
    '### set location of label list ###
    ' locate the horiz midpoint using screen UI width and the total width of the label list
    labelListX = (m.global.display.ui.width - m.labelList.boundingRect().width) / 2
    ' locate the vert midpoint using screen UI height and the total height of the label list
    labelListY = (m.global.display.ui.height - m.labelList.boundingRect().height) / 2
    ' set the label list X and Y coordinates
    m.labelList.translation = [labelListX, labelListY]

    '### set color and overall theme of label list ###
    ' check if the top level selector URI is valid and set to label list
    if m.top.getScene().selectorUri <> invalid then m.labelList.focusBitmapUri = m.top.getScene().selectorUri
    ' set the unfocused label color using the palette from the home scene node
    m.labelList.color = m.top.getScene().palette.colors.primaryTextColor
    ' set the focused label color using the palette from the home scene node
    m.labelList.focusedColor = m.top.getScene().palette.colors.primaryTextColor
end sub
sub onItemSelected(obj)
    ' get the index from the selection
    itemIndex = obj.getData()
    ' get the item from the content nodes using the item index
    itemSelected = m.labelList.content.getChild(itemIndex)
    ' observe when the exit key is selected
    if (itemSelected.title = tr("Exit"))
        ' send message to exit app
        exitApp()
    else if (itemSelected.title = tr("Home Screen"))
        ' create the home screen
	    addScreen("HomeScreen")
    end if
end sub
' capture key events from remote control
function onKeyEvent(key as string, press as boolean) as boolean
    if (press)
        if (key = "back")
            ' send message to exit app immediately
            exitApp(false)
            return true
        end if
        if (key = "up")
            return true
        end if
        if (key = "down")
            return true
        end if
    end if
    return false
end function