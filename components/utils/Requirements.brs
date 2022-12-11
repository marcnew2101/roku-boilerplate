sub initRequirements(setRequirements as boolean)
	if (setRequirements)
		logging("getting requirements...")
		requirements = createRequirements()
		if requirements <> invalid then checkRequirements(requirements)
	else
		if not m.top.getScene().startApp then m.top.getScene().startApp = true
	end if
end sub
function createRequirements() as object
	try
		logging("loading requirements file...")
		return parseJson(readAsciiFile("pkg:/components/data/requirements.json"))
	catch e
		logging("unable to read requirements.json file - " + e.message, 3)
		return invalid
	end try
end function
sub checkRequirements(requirements as object)
	pass = true
	for each requirement in requirements.items()
		' check the requirement value and proceed if true
		if (not isNullOrEmpty(requirement.value) and requirement.value["required"])
			deviceReady = getRequirement(requirement)
			' check if the requirement fails
			if (not isNullOrEmpty(deviceReady))
				if (not deviceReady)
					pass = false
					logging("(FAIL) " + requirement.key + " failed to meet requirements", 4)
					' check if the showError field in Requirements.brs is set to true
					if (requirement.value["showError"] <> invalid and requirement.value["showError"])
						' trigger the error message dialog here
						m.top.getScene().message = requirement.key
						exit for
					end if
				else
					logging("(PASS) " + requirement.key + " meets requirements", 1)
				end if
			end if
		end if
	end for
	if pass and not m.top.getScene().startApp then m.top.getScene().startApp = true
end sub
function getRequirement(requirement as object) as boolean
	v = aaContains(m.global, requirement.key, true, true)
	if (v <> invalid)
		if (isBoolean(v))
			return v
		else
			return setAsBool(requirement, v)
		end if
	end if
	return invalid
end function
function setAsBool(requirement as object, v as dynamic)
	if (requirement.key = "os")
		return getMinOS(requirement, v)
	else if (requirement.key = "model")
		return getModel(requirement, v)
	end if
end function
function getMinOS(requirement as object, os as float) as boolean
	if (os >= requirement.value["minVersion"])
		return true
	end if
	logging("current os version " + str(os) + " does not meet minimum os version " + str(requirement.value["minVersion"]), 4)
	return false
end function
function getModel(requirement as object, model as string) as boolean
	logging("getting hardware...")
	roku = findModel(model)
	if (not isNullOrEmpty(roku))
		if (roku.legacy <> invalid and roku.legacy)
			logging(roku.name + " (" + model + ") not supported", 4)
			return false
		end if
	else
		logging("roku device not found")
	end if
	return true
end function
function findModel(model)
	logging("loading hardware file...")
	try
		hardwareFile = parseJson(readAsciiFile("pkg:/components/data/hardware.json"))
		return aaContains(hardwareFile, model, true, true)
	catch e
		logging("unable to read hardware.json file - " + e.message, 3)
		return invalid
	end try
end function