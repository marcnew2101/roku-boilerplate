sub createDialog(params = {} as object)
    if params = invalid
        ? "message is not an object - Messages.brs"
        return
    end if
    if params.count() = 0
        ? "message is empty - Messages.brs"
        return
    end if
    if params.title = invalid or len(params.title) = 0
        ? "message title is required - Messages.brs"
        ? "message is: "; params
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
    messagefile = ReadAsciiFile("pkg:/components/data/messages.json")
    if messagefile = invalid then return invalid
    json = ParseJson(messagefile)
    if json = invalid then return invalid
    for each message in json.items()
        if message.key = messageString and message.value <> invalid then return message.value
    end for
    return invalid
end function
sub setMessage(message as string)
    m.top.getScene().message = message
end sub