sub init()
	' set an associate array with each child node (direct descendant) from HomeScene.xml
	' see /components/utils/Screens.brs
	getScreens()

	' set the overall look of the app (requires Roku OS 9.4 or later)
	' see /components/utils/Themes.brs
	getTheme("dark-red")
	
	' setRequirements(false) to start app right away or setRequirements(true) to specify conditions before opening app
	' see /components/utils/Requirements.brs
	startApp(setRequirements(false))
end sub

sub startApp(ready = true)
	if (ready <> Invalid AND ready)
		' certification requires the following to indicate the app is finished loading
		m.top.getScene().signalBeacon("AppLaunchComplete")
		' get the landing screen
		landingscreen = setScreen("LandingScreen")
		' check that the landing screen is not invalid
		if (landingscreen <> Invalid)
			' show initial landing screen
			landingscreen.visible = true
		end if
	else
		? "WARNING: Unable to start app from HomeScene.brs"
	end if
end sub