sub init()
	' set the overall look of the app (requires Roku OS 9.4 or later)
	' see /components/utils/Themes.brs
	setTheme("dark-red")
	
	' setRequirements(false) to start app right away or setRequirements(true) to specify conditions before opening app
	' see /components/utils/Requirements.brs
	startApp(setRequirements(false))
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

sub onError(obj)
	' get the error string
	error = obj.getData()
	' check that the error string is not invalid and not empty
	if (error <> Invalid AND len(error) > 0)
		' create error dialog screen
		createErrorDialog(getError(error))
	end if
end sub