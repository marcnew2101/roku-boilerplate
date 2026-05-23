sub init()
    ' cache the root Scene; util scripts use m.scene instead of m.top.getScene()
    m.scene = m.top.getScene()
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
    if not hasValue(params) then return invalid
    if not hasValue(params.screenName) then return invalid
    node = createObject("roSGNode", params.screenName)
    if node = invalid then return invalid
    if not hasValue(node.id) then node.id = valueOr(params.screenId, params.screenName)
    if not addHistory(node, params.showScreen, params.hidePrevScreen, params.addToStack)
        logError("error adding " + node.id + " to HomeScene", "HomeScene.brs")
        return invalid
    end if
    node.setFocus(true)
    return node
end function

sub removeNode(params as object)
    if not removeHistory(params.node, params.showPrevScreen, params.removeFromStack)
        logError("error removing node from HomeScene", "HomeScene.brs")
    end if
end sub

sub onMessage(obj)
    message = obj.getData()
    if not hasValue(message) then return
    ' guard against an unknown key so the dialog code isn't called with invalid
    params = getMessage(message)
    if params = invalid
        logError("no message found for key: " + message, "HomeScene.brs")
        return
    end if
    createDialog(params)
end sub