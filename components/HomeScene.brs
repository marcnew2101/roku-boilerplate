sub init()
	' set requirements to true if certain conditions need to be met before opening the app
	' set requirements to false to bypass and continue opening the app
	setRequirements(true)
end sub

sub setRequirements(arg)
	if (arg)
		' add any number of requirements to the object tree (AA)
		' each requirement is obtained from a global value set in Main.brs
		requirements = {
			"internet": true, 
			"minOS": true
		}
		' check the requirements set above
		startApp(checkRequirements(requirements))
	else
		' BEGIN OPENING APP
		startApp()
	end if
end sub

function checkRequirements(requirements)
	' will be set to true only after requirements are met
	deviceReady = false
	
	if (requirements.internet <> Invalid AND requirements.internet)
		' get the link/internet status from the global object
		deviceReady = showLinkStatus(m.global.linkStatus)
	end if

	if (requirements.minOS <> Invalid AND requirements.minOS)
		' get the OS version from the global object
		deviceReady = showVersion(m.global.osVersion)
	end if

	return deviceReady
end function

sub startApp(ready = true)
	if (ready)
		' show initial landing screen
		m.top.getScene().findNode("LandingScreen").visible = true
	else
		? "unable to start app - check requirements"
	end if
end sub

' initial check for an active internet connection
function showLinkStatus(status)
	if (status <> Invalid)
		if (status)
			return true
		else
			? "device does not meet minimum requirements for internet connectivity"
			? "check the internet connection on the device and try again"
			return false
		end if
	else
		? "error getting linkStatus from global values"
		return false
	end if
end function

' initial check for a compatible RokuOS version
function showVersion(currentVersion)
	' set the minimum version required here
	minVersion = 9.1

	if (currentVersion <> Invalid)
		if (currentVersion >= minVersion)
			return true
		else
			? "device does not meet minimum requirements for OS version"
			? "device version is currently " + currentVersion.toStr()
			? "minimum required version is " + minVersion.toStr()
			return false
		end if
	else
		? "error getting minOS from global values"
		return false
	end if
end function