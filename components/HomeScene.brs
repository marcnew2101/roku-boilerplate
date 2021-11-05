sub init()
	' set requirements to true if certain conditions need to be met before opening the app
	' set requirements to false to bypass and continue opening the app
	setRequirements(false)
end sub

sub setRequirements(arg)
	if (arg)
		' add any number of requirements to the object tree (AA) below
		' each requirement is obtained from a global value set in Main.brs
		' each value must match the name given in m.global
		requirements = {
			"internet": true, 
			"os": true
		}
		' check the requirements before starting the app
		startApp(checkRequirements(requirements))
	else
		' start app without any requirements
		startApp()
	end if
end sub

function checkRequirements(requirements)
	' loop over each item in the array of requirements
	for each requirement in requirements.items()
		' check that the requirement value is valid and set to true
		if (requirement.value <> Invalid AND requirement.value)
			' get the global value based on the requirement key
			deviceReady = getRequirement(requirement.key)
			' check that the value retrieved is valid
			if (deviceReady <> Invalid)
				' check that the value retrieved is true
				if (deviceReady)
					' user an uppercase form of the requirement key to show the condition has passed
					? uCase(requirement.key) + " = PASS"
				else
					' user an uppercase form of the requirement key to show the condition has failed
					? uCase(requirement.key) + " = FAIL"
					' this is where you can generate UI feedback in the form of a dialog box to inform and instruct the user about the error
					createErrorDialog(requirement.key)
					' exit the loop
					exit for
				end if
			else
				? requirement.key + " is not a valid global value. Check Main.brs to ensure that the global value exists."
				' exit the loop
				exit for
			end if
		end if
	end for

	' deviceReady is Invalid when a global variable does not exist
	' deviceReady is false when a requirement is not met
	' deviceReady is true when all requirements have passed
	return deviceReady
end function

function getRequirement(requirement)
	' ensure the argument is valid and is a string value type
	if (requirement <> Invalid AND type(requirement) = "roString")
		' set the global value
		v = m.global[requirement]
		' check if the global value is either Invalid or a boolean and return immediately
		if (v = Invalid OR type(v) = "roBoolean")
			return v
		else
			' if the global value is valid but not of type boolean then additional conditions must be set
			' send the requirement and global value to return a boolean type
			return setvToBool(requirement, v)
		end if
	end if
end function

function setvToBool(requirement, v)
	' check to see if the requirement is looking for the OS version
	if (requirement = "os")
		return setMinOS(v)
	else
		' NOTE: additional else if conditions will be required for any non boolean values
		' print the requirement and it's current value type
		? "The global key " + requirement + " has a value of type " + v + ". Create another condition to return a true or false value"
	end if
end function

' check for a compatible RokuOS version
function setMinOS(currentVersion)
	' set the minimum OS version required to run the app
	m.minVersion = 9.1

	' check that the current version is valid and is a float value
	if (currentVersion <> Invalid AND type(currentVersion) = "roFloat")
		' check if current version is the same or greater than the minimum version
		if (currentVersion >= m.minVersion)
			return true
		else
			return false
		end if
	else
		? "currentVersion in argument is invalid or of invalid type in setMinOS(currentVersion)"
		return false
	end if
end function

sub createErrorDialog(error)
	if (error <> Invalid AND type(error) = "roString")
		' conditionals can be set to console messages or UI dialog window
		if (error = "internet")
			? "Check the internet connection on this device and try again"
		else if (error = "os")
			? "This device does not meet minimum requirements for OS version " + m.minVersion.toStr() + ". From the Roku home screen go to Settings -> System -> System Update."
		else
			? "No condition created for error: " + error
		end if
	end if
end sub

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