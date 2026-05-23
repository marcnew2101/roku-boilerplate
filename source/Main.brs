sub main(args)
    '######################### DEVELOPER VARIABLES ##########################
    showDeviceInfo = false ' show device info in the console
    showAppInfo = false ' show app info in the console
    showBandwidth = false ' show bandwidth utilization
    showHttpErrors = false ' show http and url errors
    devLogging = true ' show logInfo/logDebug output (logError/logWarn always print)
    '########################################################################

    '########################### DEVICE/APP INFO ############################
    deviceInfo = setDeviceInfo()
    appInfo = setAppInfo()
    if showDeviceInfo then getDeviceInfo(deviceInfo)
    if showAppInfo then getAppInfo(appInfo)
    '########################################################################

    '########################## SCENEGRAPH SETUP ############################
    port = createObject("roMessagePort")
    screen = createObject("roSGScreen")
    setGlobals(screen, deviceInfo, appInfo, args, devLogging)
    screen.setMessagePort(port)
    scene = screen.createScene("HomeScene")
    screen.show()
    ' observing exitApp lets HomeScene break the main loop below by setting the field
    scene.observeField("exitApp", port)
    '########################################################################

    '########################## LOG SYSTEM EVENTS ###########################
    syslog = CreateObject("roSystemLog")
    syslog.setMessagePort(port)
    syslog.EnableType("http.error")
    syslog.EnableType("bandwidth.minute")
    '########################################################################

    '################### START APP AND LISTEN FOR EVENTS ####################
    while(true)
        msg = wait(0, port)
        msgType = type(msg)
        if (scene.exitApp)
            return
        end if
        if (msgType = "roSystemLogEvent" and (showHttpErrors or showBandwidth))
            i = msg.GetInfo()
            if (i.LogType = "http.error" and showHttpErrors)
                ? "HTTP error: "; i.HttpCode
                ? "Status error: "; i.Status
                ? "URL error: "; i.origUrl
                ? "IP: "; i.TargetIp
                ? " "
            else if (i.LogType = "bandwidth.minute" and showBandwidth)
                bandwidth = i.Bandwidth / 1000
                ? "Bandwidth: "; bandwidth.toStr() + " Mbps"
                ? " "
            end if
        end if
    end while
    '########################################################################
end sub

function setDeviceInfo()
    deviceInfo = createObject("roDeviceInfo")
    hdmiInfo = createObject("roHdmiStatus")
    ' active HDCP version OR a TV (set-top boxes can't validate HDCP themselves)
    hdcpStatus = len(hdmiInfo.getHdcpVersion()) > 0 or deviceInfo.getModelType() = "TV"
    os = deviceInfo.getOSVersion().major + "." + deviceInfo.getOSVersion().minor
    ' getInternetStatus exists only on OS 10.0+; older devices fall back to getLinkStatus
    if findMemberFunction(deviceInfo, "getInternetStatus") <> invalid
        internet = deviceInfo.getInternetStatus()
    else
        internet = deviceInfo.getLinkStatus()
    end if
    device = {
        "id": deviceInfo.GetChannelClientId(),
        "model": deviceInfo.getModel(),
        "type": deviceInfo.getModelType(),
        "os": os.toFloat(),
        "language": deviceInfo.getCurrentLocale(),
        "graphics": deviceInfo.getGraphicsPlatform(),
        "display": {
            "name": deviceInfo.getModelDisplayName(),
            "type": deviceInfo.GetDisplayType(),
            "ui": {
                "width": deviceInfo.getUIResolution().width,
                "height": deviceInfo.getUIResolution().height,
                "name": deviceInfo.getUIResolution().name
            },
            "video": deviceInfo.getVideoMode()
        },
        "network": {
            "internet": internet,
            "type": deviceInfo.getConnectionType(),
            "externalIP": deviceInfo.getExternalIp()
        },
        "hdmi": {
            "connected": hdmiInfo.isConnected(),
            "hdcp": hdcpStatus
        }
    }
    return device
end function

function setAppInfo()
    appInfo = createObject("roAppInfo")

    app = {
        "id": appInfo.getID(),
        "isDev": appInfo.isDev(),
        "devId": appInfo.getDevID(),
        "title": appInfo.getTitle(),
        "version": appInfo.getVersion()
    }
    return app
end function

sub getDeviceInfo(deviceInfo)
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

sub getAppInfo(appInfo)
    ? "- - - - - - - - - - - - - - - - - - -"
    ? "App ID:           "; appInfo.id
    ? "Is Dev:           "; appInfo.isDev
    ? "Dev ID:           "; appInfo.devId
    ? "Title:            "; appInfo.title
    ? "Version:          "; appInfo.version
    ? "- - - - - - - - - - - - - - - - - - -"
    ? " "
end sub

sub setGlobals(screen, deviceInfo, appInfo, deepLinkArgs, devLogging = true as boolean)
    globalNode = screen.getGlobalNode()
    globalNode.addFields({
        "deviceId": deviceInfo.id,
        "model": deviceInfo.model,
        "os": deviceInfo.os,
        "internet": deviceInfo.network.internet,
        "language": deviceInfo.language,
        "graphics": deviceInfo.graphics,
        "ui": deviceInfo.display.ui,
        "hdcp": deviceInfo.hdmi.hdcp,
        "deeplink": getDeepLinks(deepLinkArgs),
        "devLogging": devLogging
    })
end sub

function getDeepLinks(args) as object
    deeplink = invalid
    if args.contentId <> invalid and args.mediaType <> invalid
        deeplink = {
            id: args.contentId
            type: args.mediaType
        }
    end if
    return deeplink
end function