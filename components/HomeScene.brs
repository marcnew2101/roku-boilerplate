sub init()
    ' change to true for testing themes set in /components/data/themes.json
    ' the setTheme() has a 2nd argument for defining the theme ex. setTheme(true, { "type": "light", "color": "red" })
    ' ensure that both the "type" and "color" inside the object match the key/values in themes.json
    setTheme(true)
    ' set to true for forcing requirements in /components/data/requirements.json
    ' set to false to immediately return true and bypass requirements
    ' optional: test the error message for requirements by changing the minVersion in the requirements.json file from to 20.0
    requirements = setRequirements(false)
    ' start the app if all requirements are met
    if requirements then startApp()
end sub
sub startApp()
    ' create the initial screen stack array in History.brs
    initScreenStack()
    ' create the landing screen node (name) and assign an id
    ' see REAMDME for additional arguments
    addScreen("LandingScreen", "landingScreen")
end sub
function addNode(params as object) as object
    if params = invalid or params.count() = 0 then return invalid
    if params.screenName = invalid or len(params.screenName) = 0 then return invalid
    node = createObject("roSGNode", params.screenName)
    if node = invalid then return invalid
    if node.id = invalid or len(node.id) = 0
        if params.screenId <> invalid and len(params.screenId) > 0
            node.id = params.screenId
        else
            node.id = params.screenName
        end if
    end if
    if addHistory(node, params.showScreen, params.hidePrevScreen, params.addToStack)
        node.setFocus(true)
    else
        ? " "
        ? "there was an error adding " + node.id + " to HomeScene"
    end if
    return node
end function
sub removeNode(params as object)
    if (not removeHistory(params.node, params.showPrevScreen, params.removeFromStack))
        ' show a console message stating that the node could not be added to HomeScene
        ? " "
        ? "there was an error removing the node from HomeScene"
    end if
end sub
sub onMessage(obj)
    ' get the message string
    message = obj.getData()
    if (message <> invalid and len(message) > 0)
        ' guard against an unknown key so the dialog code isn't called with invalid
        params = getMessage(message)
        if (params <> invalid)
            createDialog(params)
        else
            ? "no message found for key: " + message + " - HomeScene.brs"
        end if
    end if
end sub