sub init()
	' create an associate array of all child nodes from HomeScene.xml
	setScreens()
	
	' set requirements = false to open app right away
	' set requirements = true to specify conditions before opening app - see /components/utils/Requirements.brs
	requirements = false

	' start the app
	startApp(setRequirements(requirements))
end sub

sub startApp(ready = true)
	if (ready <> Invalid AND ready)
		' certification requires the following to indicate the app is finished loading
		m.top.getScene().signalBeacon("AppLaunchComplete")
		' get the landing screen
		landingscreen = getScreen("LandingScreen")
		' check that the landing screen is not invalid
		if (landingscreen <> Invalid)
			' show initial landing screen
			landingscreen.visible = true
		end if
	else
		? "WARNING: Unable to start app from HomeScene.brs"
	end if
end sub