' requirements is true unless set otherwise
function setRequirements(args = true)
    ' add any number of requirements to the object tree (AA) below
	' each top level key is obtained from the m.global key set in Main.brs
	' the top level key must match the key in m.global
	m.requirements = {
		' first key (internet) must match the key in m.global object from Main.brs
        "internet": {
			"required": true,
			"error": {
				' set the message to appear in the onscreen dialog
				"message": "Check the internet connection on this device and try again",
				' help button will only appear if filled out below. Remove line or use empty string to not show a help button.
				"help": "From the Roku home screen, go to Settings -> Network -> Check connection.",
				' error types:
				' 1 = critical (must close app and fix before retrying) ex. no internet connection
				' 2 = warning (app remains open and user can retry last operation) ex. issue with starting playback
				' 3 = info (general info to user) ex. issue with processing payment
				"type": 1
			}
		},
		' first key (os) must match the key in m.global object from Main.brs
        "os": {
			"required": true,
			"minVersion": 9.1,
			"error": {
				"message": "This device does not meet minimum requirements for OS version 9.1",
				"help": "From the Roku home screen, go to Settings -> System -> System update."
				"type": 1
			}
		}
    }

	' check that args is not invalid and has a value of true/false
	if (args <> Invalid AND type(args) = "Boolean")
		' check if args is true
		if (args)
			' check the requirements before starting the app
			return checkRequirements(m.requirements)
		else
			' start app without any requirements
			return true
		end if
	else
		? "ERROR: setRequirements() in HomeScene.brs requires a value of true or false"
	end if
end function

function checkRequirements(requirements)
	' check that requirements is not invalid and has a value of AA
	if (requirements <> Invalid AND type(requirements) = "roAssociativeArray")
		' loop over each item in the array of requirements
		for each requirement in requirements.items()
			' check that the requirement value is valid and required key is set to true
			if (requirement.value <> Invalid AND requirement.value["required"])
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
						createErrorDialog(requirement.value["error"]) ' see /components/utils/Errors.brs
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
	else
		? "ERROR: argument is invalid or of invalid type in checkRequirements(requirements) - HomeScene.brs"
	end if
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
	else
		? "ERROR: argument is invalid or of invalid type in getRequirement(requirement) - HomeScene.brs"
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
	' check that the current version is valid and is a float value
	if (currentVersion <> Invalid AND type(currentVersion) = "roFloat")
		' check if current version is the same or greater than the minimum version
		if (currentVersion >= m.requirements.os.minVersion)
			return true
		else
			return false
		end if
	else
		? "ERROR: argument is invalid or of invalid type in setMinOS(currentVersion) - HomeScene.brs"
		return false
	end if
end function