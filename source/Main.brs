sub main(args)
	'######################### DEVELOPER VARIABLES ##########################
	showBandwidth = false ' show bandwidth utilization in console
	showHttpErrors = false ' show http and url errors in console
	'########################################################################

	'########################### DEVICE/APP INFO ############################
	' create device info object
	deviceInfo = setDeviceInfo()
	' create app/manifest info object
	appInfo = setAppInfo(args)
	'########################################################################

	'########################## SCENEGRAPH SETUP ############################
	' create message event listener
	port = createObject("roMessagePort")
	' create root scenegraph node
	screen = createObject("roSGScreen")
	' set global values using info obtained from device and app
	setGlobals(screen, deviceInfo, appInfo)
	' set the message port for screen events
	screen.setMessagePort(port)
	' create the initial scenegraph object
	scene = screen.createScene("App")
	' render the initial scenegraph object
	screen.show()
	' observe changes to exitApp interface on HomeScene
	scene.observeField("exitApp", port)
	'########################################################################

	'########################## LOG SYSTEM EVENTS ###########################
	' create system logging events
	syslog = CreateObject("roSystemLog")
	' set the message port for logging events
	syslog.setMessagePort(port)
	' enable http error logging
	syslog.EnableType("http.error")
	' enable bandwidth measurement logging
	syslog.EnableType("bandwidth.minute")
	'########################################################################

	'################### START APP AND LISTEN FOR EVENTS ####################
	' create loop to track opening and closing of app
	while(true)
		' wait indefinitely
		msg = wait(0, port)
		' get message type
		msgType = type(msg)
		' check exitApp field on HomeScene - closes app (ends while loop) when set to true
		if (scene.exitApp)
			' exit app / end while
			return
		end if
		' check if the message type is logging event and if developer variables are true
		if (msgType = "roSystemLogEvent" and (showHttpErrors or showBandwidth))
			' Handle the roSystemLogEvents:
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
function setDeviceInfo() as object
	' create device info object
	deviceInfo = createObject("roDeviceInfo")
	' create HDMI info object
	hdmiInfo = createObject("roHdmiStatus")
	' check for an active version of hdcp or a device type of "TV" - all others refer to a set top box
	if len(hdmiInfo.getHdcpVersion()) > 0 or deviceInfo.getModelType() = "TV" then hdcpStatus = true else hdcpStatus = false
	' get OS version
	os = deviceInfo.getOSVersion().major + "." + deviceInfo.getOSVersion().minor
	' determine if device will return internet status
	internetStatus = findMemberFunction(deviceInfo, "getInternetStatus")
	if (internetStatus <> invalid)
		' required minimum OS version 10.0
		internet = deviceInfo.getInternetStatus()
	else
		internet = deviceInfo.getLinkStatus()
	end if
	' create object with device info definitions
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
function setAppInfo(args) as object
	' create app info object
	appInfo = createObject("roAppInfo")
	' create object with app info definitions
	app = {
		"appId": appInfo.getID(),
		"isDev": appInfo.isDev(),
		"devId": appInfo.getDevID(),
		"title": appInfo.getTitle(),
		"appVersion": appInfo.getVersion(),
		"deeplink": getDeepLinks(args),
		"debug": stringToBool(appInfo.getValue("debug")),
		"debugLogLevel": appInfo.getValue("debug_log_level").toInt()
	}
	return app
end function
sub setGlobals(screen, deviceInfo, appInfo)
	' combine deviceInfo and appInfo as one object
	deviceInfo.append(appInfo)
	' get the global reference object
	m.global = screen.getGlobalNode()
	' assign variables to global object
	m.global.addFields(deviceInfo)
end sub
function getDeepLinks(args) as object
	deeplink = {}
	' check if both contentId and mediaType are valid
	if (args.contentId <> invalid and args.mediaType <> invalid)
		deeplink = {
			"id": args.contentId,
			"type": args.mediaType
		}
	end if
	return deeplink
end function
function stringToBool(value as string) as boolean
	if (value <> invalid and value.len() > 0)
		return lCase(value) = "true"
	end if
	return false
end function