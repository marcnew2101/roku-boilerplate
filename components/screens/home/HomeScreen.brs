sub init()
end sub
' capture key events from remote control
function onKeyEvent(key as string, press as boolean) as boolean
    if (press)
        if (key = "back")
            ' send message to exit app
            exitApp()
            return true
        end if
        if (key = "options")
            ' animate side menu open/close
            
            return true
        end if
        if (key = "up")
            return true
        end if
        if (key = "down")
            return true
        end if
    end if
    return false
end function