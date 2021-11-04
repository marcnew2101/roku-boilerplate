sub init()
    ' ### node identifiers ###
    ' identify the label list
    m.labelList = m.top.findNode("landingLabelList")

    ' ### node observers ###
    ' observe screen visibility
    m.top.observeField("visible", "screenVisible")
    ' observe button presses on the label list
    m.labelList.observeField("itemSelected", "onItemSelected")
end sub

sub screenVisible(obj)
    visible = obj.getData()
    if (visible)
        ? "LandingScreen is now visible"
        ' populate the label list with content
        populateLabelList()
        ' center the label list on the screen
        centerLabelList()
        ' set key focus to label list
        m.labelList.setFocus(true)
    end if
end sub

sub populateLabelList()
    ' create array of strings to be displayed in the label list
    listItems = [
        "Sign In",
        "Sign Up",
        "Exit"
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
    ' set the total screen width and height
    screenWidth = 1920
    screenHeight = 1080

    ' subtract the label list width from the screen width and divide in half
    labelListX = (screenWidth - m.labelList.boundingRect().width) / 2
    ' subtract the label list height from the screen height and divide in half
    labelListY = (screenHeight - m.labelList.boundingRect().height) / 2

    ' set the label list X and Y coordinates
    m.labelList.translation = [labelListX, labelListY]
end sub

sub onItemSelected(obj)
    ' get the index from the selection
    itemIndex = obj.getData()

    ' get the item from the content nodes using the item index
    itemSelected = m.labelList.content.getChild(itemIndex)

    ' print the label string
    ? itemSelected.title

    ' observe when the exit key is selected
    if (itemSelected.title = "Exit")
        ' set the home scene exitApp interface to close the app
        m.top.getScene().exitApp = true
    end if
end sub

' capture key events from remote control
function onKeyEvent(key as String, press as Boolean) as Boolean
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