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
	' create the initial screen stack array in History.brs
	initScreenStack()

	' create the landing screen node (name) and assign an id
	' see REAMDME for additional arguments (history)
	setScreen("LandingScreen", "landingScreen")
	' certification requires the following to indicate the app is finished loading
	m.top.getScene().signalBeacon("AppLaunchComplete")
end sub
function createNode(params as object)
	' check that the object from params is valid
	if (params <> invalid and params.count() > 0)
		' check that the screenName value in the object is valid
		if (params.screenName <> invalid and len(params.screenName) > 0)
			' create the node using the params.screen value
			node = createObject("roSGNode", params.screenName)
			' check that the created node is valid
			if (node <> invalid)
				' check if the node ID is not yet assigned
				if (node.id = invalid)
					' check if the screenId is valid and has a string length greater than zero
					if (params.screenId <> invalid and len(params.screenId) > 0)
						' assign the node ID using params.screenId
						node.id = params.screenId
					else
						' assign the node ID usind params.screenName
						node.id = params.screenName
					end if
				end if
				' add the screen to History.brs
				addScreen(node, params.showScreen, params.hidePrevScreen, params.addToStack)
				' return the node
				return node
			end if
		end if
	end if
end function
sub onMessage(obj)
	' get the message string
	message = obj.getData()
	' check that the message string is not invalid and not empty then create message dialog
	if message <> invalid and len(message) > 0 then createDialog(getMessage(message))
end sub