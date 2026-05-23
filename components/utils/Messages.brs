sub createDialog(params = {} as object)
    if params = invalid
        logError("message is not an object", "Messages.brs")
        return
    end if
    if params.count() = 0
        logError("message is empty", "Messages.brs")
        return
    end if
    if params.title = invalid or len(params.title) = 0
        logError("message title is required; contents: " + FormatJson(params), "Messages.brs")
        return
    end if
    if screenExists("dialogModal")
        screen = getScreen("dialogModal")
    else
        screen = addScreen("DialogModal", "dialogModal", true, false)
    end if
    if screen <> invalid then showDialog(params, screen)
end sub
sub showDialog(params as object, screen as object)
    screen.dialogInfo = params
end sub
function getMessage(messageString = "" as string)
    ' parse messages.json once per component instance; the file ships in the package and never changes at runtime
    if m.messageCache = invalid
        messagefile = ReadAsciiFile(Const().path.messages)
        if messagefile = invalid then return invalid
        json = ParseJson(messagefile)
        if json = invalid then return invalid
        m.messageCache = json
    end if
    for each message in m.messageCache.items()
        if message.key = messageString and message.value <> invalid then return message.value
    end for
    return invalid
end function