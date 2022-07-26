sub main()
	'######################### DEVELOPER VARIABLES ##########################
	showDeviceInfo = false ' show device info in the console
	showAppInfo = false ' show app info in the console
	showBandwidth = false ' show bandwidth utilization
	showHttpErrors = false ' show http and url errors
	'########################################################################

	'########################### DEVICE/APP INFO ############################
	' create device info object
	deviceInfo = setDeviceInfo()
	' create app/manifest info object
	appInfo = setAppInfo()
	' print device info to console
	if showDeviceInfo then getDeviceInfo(deviceInfo)
	' print app info to console
	if showAppInfo then getAppInfo(appInfo)
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
	scene = screen.createScene("HomeScene")
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
			' exit app / end while loop
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
				? ""
			else if (i.LogType = "bandwidth.minute" and showBandwidth)
				bandwidth = i.Bandwidth / 1000
				? "Bandwidth: "; bandwidth.toStr() + " Mbps"
				? ""
			end if
		end if
	end while
	'########################################################################
end sub

function setDeviceInfo()
	' create device info object
	deviceInfo = createObject("roDeviceInfo")
	' create HDMI info object
	hdmiInfo = createObject("roHdmiStatus")
	' required minimum OS version 10.0
	os = deviceInfo.getOSVersion().major + "." + deviceInfo.getOSVersion().minor
	' determine if device will return internet status
	internetStatus = findMemberFunction(deviceInfo, "getInternetStatus")
	if (internetStatus <> invalid)
		' required minimum OS version 10.0
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
			"size": deviceInfo.getDisplaySize().w.toStr() + " x " + deviceInfo.getDisplaySize().h.toStr(),
			"ui": deviceInfo.getUIResolution().name,
			"video": deviceInfo.getVideoMode()
		},
		"network": {
			"internet": internet,
			"type": deviceInfo.getConnectionType(),
			"externalIP": deviceInfo.getExternalIp()
		},
		"hdmi": {
			"connected": hdmiInfo.isConnected(),
			"hdcp": {
				"active": hdmiInfo.isHdcpActive("1.4"),
				"version": hdmiInfo.getHdcpVersion()
			}
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
	' show information about device
	? "- - - - - - - - - - - - - - - - - - -"
	? "Model:            "; deviceInfo.model
	? "Type:             "; deviceInfo.type
	? "OS Version:      "; deviceInfo.os
	? "Language:         "; deviceInfo.language
	? "Graphics:         "; deviceInfo.graphics
	? "Display Name:     "; deviceInfo.display.name
	? "Display Type:     "; deviceInfo.display.type
	? "Display Size:     "; deviceInfo.display.size
	? "UI Resolution:    "; deviceInfo.display.ui
	? "Video Mode:       "; deviceInfo.display.video
	? "Internet Status:  "; deviceInfo.network.internet
	? "Connection Type:  "; deviceInfo.network.type
	? "External IP:      "; deviceInfo.network.externalIP
	? "HDMI Status:      "; deviceInfo.hdmi.connected
	? "HDCP Valid:       "; deviceInfo.hdmi.hdcp.active
	? "HDCP Version:     "; deviceInfo.hdmi.hdcp.version
	? "- - - - - - - - - - - - - - - - - - -"
	? ""
end sub

sub getAppInfo(appInfo)
	' show information about app
	? "- - - - - - - - - - - - - - - - - - -"
	? "App ID:           "; appInfo.id
	? "Is Dev:           "; appInfo.isDev
	? "Dev ID:           "; appInfo.devId
	? "Title:            "; appInfo.title
	? "Version:          "; appInfo.version
	? "- - - - - - - - - - - - - - - - - - -"
	? ""
end sub

sub setGlobals(screen, deviceInfo, appInfo)
	' get the global reference object
	m.global = screen.getGlobalNode()
	' assign variables to global object
	m.global.addFields({
		"deviceId": deviceInfo.id,
		"model": deviceInfo.model,
		"os": deviceInfo.os,
		"internet": deviceInfo.network.internet,
		"language": deviceInfo.language,
		"graphics": deviceInfo.graphics
	})
end sub