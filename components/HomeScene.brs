sub init()
	' change to true for testing themes set in /components/data/themes.json
	' the setTheme() has a second argument for defining the theme ex. setTheme(true, { "type": "light", "color": "red" })
	' ensure that both the "type" and "color" inside the object match the key/values in themes.json
	setTheme(true)

	' set to true for forcing requirements in /components/data/requirements.json
	' set to false to immediately return true and bypass requirements
	' optional: test the error message for requirements by changing the minVersion in the requirements.json file from to 20.0
	requirements = setRequirements(false)
	' start the app if all requirements are met
	if requirements then startApp()
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