' Show a dialog with the given config. See README for config shape and button-press behavior.
sub showDialog(config as object)
    if not hasValue(config)
        logError("showDialog called with invalid config", "Messages.brs")
        return
    end if
    if not hasValue(config.buttons)
        logError("showDialog: at least one button required", "Messages.brs")
        return
    end if

    i = 0
    for each btn in config.buttons
        if not hasValue(btn.label)
            logWarn("showDialog: button missing label at index " + i.toStr(), "Messages.brs")
        end if
        i = i + 1
    end for

    if screenExists("DialogModal")
        screen = getScreen("DialogModal")
    else
        screen = addScreen("DialogModal", true, false)
    end if
    if screen <> invalid then screen.dialogInfo = config
end sub

' Convenience: load a dialog config from messages.json by key and show it.
sub showMessage(messageKey as string)
    config = getMessage(messageKey)
    if not hasValue(config)
        logError("showMessage: no entry for key '" + messageKey + "'", "Messages.brs")
        return
    end if
    showDialog(config)
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
