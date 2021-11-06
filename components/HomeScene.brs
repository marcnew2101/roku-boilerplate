sub init()
	' set requirements to false and open app right away
	' set requirements to true and specify conditions before opening app - see /components/utils/Requirements.brs
	requirements = false

	' start the app
	startApp(setRequirements(requirements))
end sub

sub startApp(ready = true)
	if (ready <> Invalid AND ready)
		' certification requires the following to indicate the app is finished loading
		m.top.getScene().signalBeacon("AppLaunchComplete")
		' show initial landing screen
		m.top.getScene().findNode("LandingScreen").visible = true
	else
		? "WARNING: Unable to start app - HomeScene.brs"
	end if
end sub