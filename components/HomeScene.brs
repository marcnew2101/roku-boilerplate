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

sub onError(obj)
	' get the error string
	error = obj.getData()
	' check that the error string is not invalid and not empty then create error dialog
	if error <> invalid and len(error) > 0 then createErrorDialog(getError(error))
end sub