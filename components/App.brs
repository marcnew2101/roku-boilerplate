sub init()
	' true: set config and global values (/components/data/config.json)
	' false: bypass config
	initConfiguration(true)
	' start prelaunch
	preLaunch()
end sub
sub preLaunch()
	' true: set theme (/components/data/themes.json)
	' false: bypass theme
	' optional: set additional arguments to customize the theme ex. initTheme(true, "light", "red")
	initTheme(true)
	' true: set requirements (/components/data/requirements.json)
	' false: bypass requirements
	initRequirements(true)
end sub
sub startApp()
	' create the initial screen stack array in History.brs
	initScreenStack()
	' create the landing screen
	addScreen("LandingScreen")
end sub
function addNode(params as object) as object
	' check that the object from params is valid
	if (params <> invalid and params.count() > 0)
		' check that the screenName value in the object is valid
		if (not isNullOrEmpty(params.screenName))
			' create the node using the params.screen value
			node = createObject("roSGNode", params.screenName)
			' check that the created node is valid
			if (node <> invalid)
				' check if the node ID is not yet assigned
				if (node.id = invalid or (node.id <> invalid and len(node.id) = 0))
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
				if (not addHistory(node, params.showScreen, params.hidePrevScreen, params.addToStack))
					logging("there was an error adding " + node.id + " to HomeScene", 3)
				else
					' set focus to node
					node.setFocus(true)
				end if
				' return the node
				return node
			end if
		end if
	end if
end function
sub removeNode(params as object)
	if (not removeHistory(params.node, params.showPrevScreen, params.removeFromStack))
		logging("there was an error removing " + params.node.id + " from HomeScene", 3)
	end if
end sub
sub onMessage(obj)
	' get the message string
	message = obj.getData()
	' check that the message string is not invalid and not empty then create message dialog
	if not isNullOrEmpty(message) then createDialog(getMessage(message))
end sub