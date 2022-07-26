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
        ' populate the title label
        populateLandingTitle()
        ' populate the label list with content
        populateLabelList()
        ' center the label list on the screen
        centerLabelList()
        ' set key focus to the label list
        m.labelList.setFocus(true)
    end if
end sub

sub populateLandingTitle()
    ' set the text string for the title label - tr() is optional for translating the string to another language
    m.landingTitle.text = tr("Welcome To The Landing Screen")
    ' set the font size for the title label
    m.landingTitle.font.size = 62
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

sub centerLabelList()
    ' subtract the label list width from the screen width and divide
    labelListX = (1920 - m.labelList.boundingRect().width) / 2
    ' subtract the label list height from the screen height and divide
    labelListY = (1080 - m.labelList.boundingRect().height) / 2
    ' set the label list X and Y coordinates
    m.labelList.translation = [labelListX, labelListY]
end sub

sub onItemSelected(obj)
    ' get the index from the selection
    itemIndex = obj.getData()
    ' get the item from the content nodes using the item index
    itemSelected = m.labelList.content.getChild(itemIndex)
    ' observe when the exit key is selected
    if (itemSelected.title = tr("Exit"))
        ' set the home scene exitApp interface to close the app
        m.top.getScene().exitApp = true
    end if
end sub

' capture key events from remote control
function onKeyEvent(key as string, press as boolean) as boolean
    if (press)
        if (key = "back")
            ? "back key pressed"
            return false
        end if

        if (key = "up")
            ? "up key pressed"
            return true
        end if

        if (key = "down")
            ? "down key pressed"
            return true
        end if
    end if
    return false
end function