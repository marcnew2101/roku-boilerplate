' requirements is true unless set otherwise
function setRequirements(args = true)
    ' see function on how to create requirements for opening app
	m.requirements = createRequirements()

	' check that args is not invalid and has a value of true/false
	if (args <> Invalid AND type(args) = "Boolean")
		' check if args is true
		if (args)
			' check that the requirements are not Invalid before sending for verification
			if m.requirements <> Invalid then return checkRequirements(m.requirements)
		else
			' start app without any requirements
			return true
		end if
	else
		? "ERROR: setRequirements() requires a value of true or false - HomeScene.brs"
	end if
end function

function createRequirements()
	' add any number of requirements to the object tree (AA) below
	' each top level key is obtained from the m.global key set in Main.brs
	' the top level key must match the key set in m.global
	return {
		' first key (internet) must match the key in m.global object from Main.brs
        "internet": {
			"required": true,
			' OPTIONAL: this is where you set each of the error requirements that will appear on the dialog pop-up in /components/screens/dialogs/DialogModal.xml
			' the error object and all its key/values can be removed if no error message is needed to appear to the user
			"error": {
				' set the error title to appear at the top of the dialog box. Remove this line or leave empty string to hide title.
				"title": "NO INTERNET CONNECTION",
				' set the main message to appear in the onscreen dialog box - this is required for the message pop-up to work.
				"message": "Check the internet connection on this device and try again",
				' set any number of help messages to appear below the error message. Remove this line or use an empty array "[]" to hide the help message.
				"help": [
					"From the Roku home screen, go to Settings -> Network -> Check connection.",
					"If the internet connection continues to fail, try restarting the Roku from Settings -> System -> System restart."
				],
				' set any number of buttons to appear at the bottom of the dialog box. Remove this line or use an empty array "[]" to hide the buttons.
				"buttons": ["OKAY"],
				' set to true to immediately close the app after error pressing okay on error window or false to continue letting the user interact with the UI
				"exitApp": true
			}
		},
        "os": {
			"required": true,
			' set the minimum version here as well as in the error message below
			"minVersion": 9.1,
			"error": {
				"title": "ROKU UPDATE REQUIRED",
				"message": "This device does not meet minimum requirements for OS version 9.1",
				"help": [
					"From the Roku home screen, go to Settings -> System -> System update.",
					"If your Roku cannot be updated to the minimum required version, you will need to obtain a newer Roku device."
				],
				"buttons": ["OKAY"],
				"exitApp": true
			}
		}
    }
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
						? uCase(requirement.key) + " CHECK = PASS"
					else
						' user an uppercase form of the requirement key to show the condition has failed
						? uCase(requirement.key) + " CHECK = FAIL"
						' this is where you can generate UI feedback in the form of a dialog box to inform and instruct the user about the error
						createErrorDialog(requirement.value["error"]) ' see /components/utils/Errors.brs
						' exit the loop
						exit for
					end if
				else
					? requirement.key + " is not a valid global key/value. Check Main.brs to ensure that the requirement exists - HomeScene.brs"
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
			' if the global value is valid but not of type boolean (true/false)
			' then we need to send the requirement and value (v) to return a boolean type value
			return setAsBool(requirement, v)
		end if
	else
		? "ERROR: argument is invalid or of invalid type in getRequirement(requirement) - HomeScene.brs"
	end if
end function

function setAsBool(requirement, v)
	' check to see if the requirement is looking for the OS version
	if (requirement = "os")
		' send the value (v) to be returned as a conditional true or false value
		return setMinOS(v)
	else
		' NOTE: additional else if conditions will be required for any non boolean type values
		' print the following to show the requirement and value and explain that it will need a special condition to return a true or false value
		? requirement + " has a value of type " + v + " in setvToBool(requirement, v). Create another elseif condition to return a true or false value. - HomeScene.brs"
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