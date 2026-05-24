' Centralized logging. Errors/warnings always print; info/debug gated on m.global.devLogging.
' Source arg is optional but useful for grep — see README for the level table.
sub logError(msg as string, source = "" as string)
    ? " "
    ? "[ERROR] " + msg + sourceTag(source)
end sub

sub logWarn(msg as string, source = "" as string)
    ? "[WARN] " + msg + sourceTag(source)
end sub

sub logInfo(msg as string, source = "" as string)
    if not devLoggingEnabled() then return
    ? "[INFO] " + msg + sourceTag(source)
end sub

sub logDebug(msg as string, source = "" as string)
    if not devLoggingEnabled() then return
    ? "[DEBUG] " + msg + sourceTag(source)
end sub

function sourceTag(source as string) as string
    if len(source) = 0 then return ""
    return "  (" + source + ")"
end function

function devLoggingEnabled() as boolean
    return m.global <> invalid and m.global.devLogging = true
end function
