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
	' deviceReady will be Invalid when a global variable does not exist
	' deviceReady will be false when a requirement is not met
	deviceReady = true
	
	' ensure that none of the global variables returns as Invalid
	if (deviceReady <> Invalid)
		' ensure that each of the requirements is met
		if (deviceReady)
			' check that the requirement exists and is set to true
			if (requirements.internet <> Invalid AND requirements.internet)
				' get the link/internet status from the global object
				deviceReady = showLinkStatus(m.global.linkStatus)
				? "Internet PASS = " + deviceReady.toStr()
			end if
			' check that the requirement exists and is set to true
			if (requirements.minOS <> Invalid AND requirements.minOS)
				' get the OS version from the global object
				deviceReady = showVersion(m.global.osVersion)
				? "Version PASS = " + deviceReady.toStr()
			end if
		else
			? "One or more requirements was not met. Check console for PASS status."
		end if
	else
		? "One or more global variables is invalid. Check Main.brs to ensure that the data is valid."
	end if

	return deviceReady
end function

sub startApp(ready = true)
	if (ready <> Invalid AND ready)
		' certification requires the following to indicate the app is finished loading
		m.top.getScene().signalBeacon("AppLaunchComplete")
		' show initial landing screen
		m.top.getScene().findNode("LandingScreen").visible = true
	else
		? "Unable to start app - check requirements"
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