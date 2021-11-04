sub main()

'######################### DEVELOPER VARIABLES ##########################
	showDeviceInfo = true		' show device and app info in the console
	showBandwidth = false		' show info about bandwidth utilization
	showHttpErrors = false		' show http and url errors
'########################################################################

	' create device info object
	deviceInfo = createObject("roDeviceInfo")
	' create manifest/app info object
	appInfo = createObject("roAppInfo")
	' create HDMI info object
	hdmiInfo = createObject("roHdmiStatus")
	' create message event listener
	port = createObject("roMessagePort")
	' create root scenegraph node
	screen = createObject("roSGScreen")
	' create system logging events
	syslog = CreateObject("roSystemLog")

	' determine if device will return version info
	osVersionStatus = findMemberFunction(deviceInfo, "getOSVersion")
	' determine if device will return internet status
	internetStatus = findMemberFunction(deviceInfo, "getInternetStatus")

	' print device info to console
	if (showDeviceInfo)
		' show information about device
		? "- - - - - - - - - - - - -"
		? "Model:         "; deviceInfo.getModel()
		? "Type:          "; deviceInfo.getModelType()
		if (osVersionStatus <> Invalid)
			' required minimum OS version 9.2
			? "OS Version:    "; deviceInfo.getOSVersion().major + "." + deviceInfo.getOSVersion().minor
		else
			osVersion = deviceInfo.getVersion()
			major = mid(osVersion, 3, 1)
			minor = mid(osVersion, 5, 2)
			? "OS Version:    "; major + "." + minor
		end if
		? "Display Name:  "; deviceInfo.getModelDisplayName()
		? "Display Type:  "; deviceInfo.GetDisplayType()
		display_size = deviceInfo.getDisplaySize()
		? "Display Size: "; display_size.w; " x"; display_size.h
		? "UI Resolution: "; deviceInfo.getUIResolution().name
		? "Video Mode:    "; deviceInfo.getVideoMode()
		? "Graphics:      "; deviceInfo.getGraphicsPlatform()
		if (internetStatus <> Invalid)
			' required minimum OS version 10.0
			? "Link Status:   "; deviceInfo.getInternetStatus()
		else
			? "Link Status:   "; deviceInfo.getLinkStatus()
		end if
		if (deviceInfo.getConnectionType() <> "")
			? "Connection:    "; deviceInfo.getConnectionType()
		else
			? "Connection:    None"
		end if
		? "Language:      "; deviceInfo.getCurrentLocale()
		? "External IP:   "; deviceInfo.getExternalIp()
		if (hdmiInfo.isConnected())
			? "HDMI Status:   HDMI is connected"
		else
			? "HDMI Status:   HDMI is not connected"
		end if
		? "HDCP Version:  "; hdmiInfo.getHdcpVersion()
		if (hdmiInfo.isHdcpActive("1.4"))
			? "HDCP Status:   valid"
		else
			? "HDCP Status:   invalid"
		end if
		' show information about app
		? ""
		? "App ID:   "; appInfo.getID()
		? "Is Dev:   "; appInfo.isDev()
		? "Dev ID:   "; appInfo.getDevID()
		? "Title:    "; appInfo.getTitle()
		? "Version:  "; appInfo.getVersion()
		? "- - - - - - - - - - - - -"
		? ""
	end if

' ######################## GLOBAL VARIABLES ###########################

	' roku device id
	deviceId = deviceInfo.GetChannelClientId()
	' roku firmware version
	if (osVersionStatus <> Invalid)
		' required minimum OS version 9.2
		osVersion = deviceInfo.getOSVersion().major + "." + deviceInfo.getOSVersion().minor
		osVersion = osVersion.toFloat()
	else
		version = deviceInfo.getVersion()
		major = mid(version, 3, 1)
		minor = mid(version, 5, 2)
		mm = major + "." + minor
		osVersion = mm.toFloat()
	end if
	' roku network connection status
	if (internetStatus <> Invalid)
		' required minimum OS version 10.0
		linkStatus = deviceInfo.getInternetStatus()
	else
		linkStatus = deviceInfo.getLinkStatus()
	end if
	' roku language from settings
	language = deviceInfo.getCurrentLocale()
	' roku graphics engine - opengl, directfb
	graphics = deviceInfo.getGraphicsPlatform()

	' get the global reference object
	m.global = screen.getGlobalNode()
	' assign variables to global object
	m.global.addFields({ 
		"deviceId": deviceId, 
		"osVersion": osVersion,
		"linkStatus": linkStatus, 
		"language": language, 
		"graphics": graphics
	})

' ######################################################################

	' set the message port for screen events
	screen.setMessagePort(port)
	' create the initial scenegraph object
	scene = screen.createScene("HomeScene")
	' render the initial scenegraph object
	screen.show()

	' observe changes to exitApp interface on HomeScene
	scene.observeField("exitApp", port)

	' set the message port for logging events
	syslog.setMessagePort(port)
	' enable http error logging
	syslog.EnableType("http.error")
	' enable bandwidth measurement logging
    syslog.EnableType("bandwidth.minute")

	' create loop to track opening and closing of app
	while(true)
		' wait indefinitely
		msg = wait(0, port)
		' get message type
		msgType = type(msg)

		' check exitApp field on HomeScene when set to true
		if (scene.exitApp)
			' exit app
			return
		end if

		' check if the message type is logging event and if developer variables are true
		if (msgType = "roSystemLogEvent" AND (showHttpErrors OR showBandwidth))
			' Handle the roSystemLogEvents:
			i = msg.GetInfo()
			if (i.LogType = "http.error" AND showHttpErrors)
				? "HTTP error: "; i.HttpCode
				? "Status error: "; i.Status
				? "URL error: "; i.origUrl
				? "IP: "; i.TargetIp
				? ""
			else if (i.LogType = "bandwidth.minute" AND showBandwidth)
				bandwidth = i.Bandwidth / 1000
				? "Bandwidth: "; bandwidth.toStr() + " Mbps"
				? ""
			end If
		end If
	end while
end sub