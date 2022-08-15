sub init()
	setRequirements(false)
	setTheme(false)
	startApp()
end sub
sub startApp()
	' certification requires the following to indicate the app is finished loading
	m.top.getScene().signalBeacon("AppLaunchComplete")
	' get the landing screen
	landingscreen = getScreen("LandingScreen")
	' check that the landing screen is not invalid and show screen
	if landingscreen <> invalid then landingscreen.visible = true
end sub
sub onMessage(obj)
	' get the message string
	message = obj.getData()
	' check that the message string is not invalid and not empty then create message dialog
	if message <> invalid and len(message) > 0 then createDialog(getMessage(message))
end sub