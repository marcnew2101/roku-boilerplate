sub init()
    ' setTheme(true) applies default; pass {"type":"light","color":"red"} matching /components/data/themes.json to override
    setTheme(true)
    ' setRequirements(true) enforces /components/data/requirements.json; bump minVersion there to test the OS-update error path
    requirements = setRequirements(false)
    if requirements then startApp()
end sub
sub startApp()
    initScreenStack()
    ' see README for addScreen() arguments
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
        logError("error adding " + node.id + " to HomeScene", "HomeScene.brs")
    end if
    return node
end function
sub removeNode(params as object)
    if not removeHistory(params.node, params.showPrevScreen, params.removeFromStack)
        logError("error removing node from HomeScene", "HomeScene.brs")
    end if
end sub
sub onMessage(obj)
    message = obj.getData()
    if message = invalid or len(message) = 0 then return
    ' guard against an unknown key so the dialog code isn't called with invalid
    params = getMessage(message)
    if params = invalid
        logError("no message found for key: " + message, "HomeScene.brs")
        return
    end if
    createDialog(params)
end sub