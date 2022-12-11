sub logging(message as string, logLevel = 0 as integer, showTimeStamp = true as boolean, debug = m.global.debug as boolean, debugLevel = m.global.debugLevel as integer)
    if (debug <> invalid and debug)
        if (debugLevel <> invalid and logLevel >= debugLevel)
            if (showTimeStamp)
                timeStamp = formatTimeStamp()
            else
                timeStamp = ""
            end if
            print getLogType(logLevel);tab(10)timeStamp + message
        end if
    end if
end sub
function getLogType(logLevel as integer) as string
    logString = "VERBOSE"
    if (logLevel = 1)
        logString = "INFO"
    else if (logLevel = 2)
        logString = "WARN"
    else if (logLevel = 3)
        logString = "ERROR"
    else if (logLevel = 4)
        logString = "FATAL"
    end if
    return "[" + logString + "] "
end function
function formatTimeStamp(dateTime = createObject("roDateTime") as object) as string
    dateTime.toLocalTime()
    dateToISO = dateTime.toISOString("milliseconds").replace("Z", "")
    dateFormat = dateTime.asDateString("short-date-dashes")
    timeFormat = dateToISO.split("T")[1]
    return dateFormat.left(len(dateFormat) - 3) + " " + timeFormat + " "
end function
sub showDeviceInfo(deviceInfo = m.global as object)
	' show information about device
	? "- - - - - - - - - - - - - - - - - - -"
	? "Model:            "; deviceInfo.model
	? "Type:             "; deviceInfo.type
	? "OS Version:      "; deviceInfo.os
	? "Language:         "; deviceInfo.language
	? "Graphics:         "; deviceInfo.graphics
	? "Display Name:     "; deviceInfo.display.name
	? "Display Type:     "; deviceInfo.display.type
	? "UI Resolution:    "; deviceInfo.display.ui.name
	? "Video Mode:       "; deviceInfo.display.video
	? "Internet Status:  "; deviceInfo.network.internet
	? "Connection Type:  "; deviceInfo.network.type
	? "External IP:      "; deviceInfo.network.externalIP
	? "HDMI Status:      "; deviceInfo.hdmi.connected
	? "HDCP Valid:       "; deviceInfo.hdmi.hdcp
	? "- - - - - - - - - - - - - - - - - - -"
	? " "
end sub
sub showAppInfo(appInfo = m.global as object)
	' show information about app
	? "- - - - - - - - - - - - - - - - - - -"
	? "App ID:   "; appInfo.appId
	? "Is Dev:   "; appInfo.isDev
	? "Dev ID:   "; appInfo.devId
	? "Title:    "; appInfo.title
	? "Version:  "; appInfo.appVersion
	? "- - - - - - - - - - - - - - - - - - -"
	? " "
end sub