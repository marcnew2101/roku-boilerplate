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
    ' set the text string for the title label - tr() is optional for translating the string to another language
    m.landingTitle.text = tr("Welcome To The Landing Screen")
    ' set the font size for the title label
    m.landingTitle.font.size = 62
    ' set the label color using the palette from the home scene node
    m.landingTitle.color = m.top.getScene().palette.colors.primaryTextColor
end sub
sub populateLabelList()
    ' create array of strings to be displayed in the label list
    ' tr() is optional for translating to another language
    listItems = [
        tr("Sign In"),
        tr("Register"),
        tr("Exit")
    ]
    ' create parent content node
    parentNode = createObject("roSGNode", "ContentNode")
    ' loop over the list items
    for each item in listItems
        ' create child content node to hold list data
        childNode = createObject("roSGNode", "ContentNode")
        ' use the list item string as the title for the content node
        childNode.title = item
        ' add the child node to the parent node
        parentNode.appendChild(childNode)
    end for
    ' assign the parent node to the label list content
    m.labelList.content = parentNode
end sub
sub setLabelList()
    '### set location of label list ###
    ' locate the horiz midpoint using screen UI width and the total width of the label list
    labelListX = (m.global.ui.width - m.labelList.boundingRect().width) / 2
    ' locate the vert midpoint using screen UI height and the total height of the label list
    labelListY = (m.global.ui.height - m.labelList.boundingRect().height) / 2
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
        m.top.getScene().message = "exit"
    end if
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