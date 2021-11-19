' requirements is true unless set otherwise
function setRequirements(params = true)
    ' see function on how to create requirements before opening app
	m.requirements = createRequirements()

	' check that params is not invalid and has a value of true/false
	if (params <> Invalid AND type(params) = "Boolean")
		' check if params is true
		if (params)
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
	' create any number of requirements in the object tree (AA) below
	' each top level key is obtained from the m.global key set in Main.brs - setGlobals()
	' the top level key must match the key set in m.global.*
	return {
        "internet": {
			"required": true,
			' the actual error that appears to the user is defined at /components/data/errors.json
			"error": true
		},
        "os": {
			"required": true,
			"minVersion": 9.1,
			"error": true
		},
		"model": {
			"required": true,
			"error": true
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
						' check if the requirement sends an error
						if (requirement.value["error"])
							' user an uppercase form of the requirement key to show the condition has failed
							? uCase(requirement.key) + " CHECK = FAIL"
							' this will generate UI feedback in the form of a dialog box to inform and instruct the user about the error
							m.top.error = requirement.key
							' exit the loop
							exit for
						end if
					end if
				else
					? requirement.key + " is not a valid global key/value. Check Main.brs to ensure that the requirement exists - Requirements.brs"
					' exit the loop
					exit for
				end if
			end if
		end for

		return deviceReady
	else
		? "ERROR: argument is invalid or of invalid type in checkRequirements(requirements) - Requirements.brs"
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
		? "ERROR: argument is invalid or of invalid type in getRequirement(requirement) - Requirements.brs"
	end if
end function

function setAsBool(requirement, v)
	' check to see if the requirement is looking for the OS version
	if (requirement = "os")
		' send the value (v) to be returned as a conditional true or false value
		return getMinOS(v)
	else if (requirement = "model")
		return getModel(v)
	else
		' NOTE: additional else if conditions will be required for any non boolean type values
		' print the following to show the requirement and value and explain that it will need a special condition to return a true or false value
		? requirement + " has a value of type " + v + " in setAsBool(requirement, v). Create another elseif condition to return a true or false value. - Requirements.brs"
	end if
end function

' check for a compatible RokuOS version
function getMinOS(currentVersion)
	' check that the current version is valid and is a float value
	if (currentVersion <> Invalid AND type(currentVersion) = "roFloat")
		' check if current version is the same or greater than the minimum version
		if (currentVersion >= m.requirements.os.minVersion)
			return true
		else
			return false
		end if
	else
		? "ERROR: argument is invalid or of invalid type in setMinOS(currentVersion) - Requirements.brs"
		return false
	end if
end function

' check for a compatible Roku model
function getModel(model)
	' check that the current version is valid and is a float value
	if (model <> Invalid AND type(model) = "roString")
		' set a list of unsupported roku hardware model numbers
		isModelSupported = setUnsupportedModels(model)
		' check that the current version is valid and is a float value
		if (isModelSupported <> Invalid AND isModelSupported)
			return true
		else
			return false
		end if
	else
		? "ERROR: argument is invalid or of invalid type in getModel(model) - Requirements.brs"
	end if
end function

function setUnsupportedModels(model)
	' array of discontinued roku devices (cannot update past version 3.1)
	' other models (not listed here) such as Giga, Paolo, Jackson, Briscoe, Littlefield are supported but may have performace issues
	' see https://developer.roku.com/docs/specs/hardware.md for an additional list of supported hardware
	legacyModels = [
		"N1000",
		"N1050",
		"N1100",
		"N1101",
		"2000C",
		"2050X",
		"2050N",
		"2100X",
		"2100N"
	]

	' set device compatibility to be true initially
	compatibleDevice = true
	' loop over the array of unsupported legacy models
	for each legacyModel in legacyModels
		' check if the currently used model is a match
		if (model = legacyModel)
			' set compability to false
			compatibleDevice = false
			? "Roku model " + model + " found in legacyModels array of setUnsupportedModel(model) - Requirements.brs"
			' exit the for loop
			exit for
		end if
	end for

	return compatibleDevice
end function