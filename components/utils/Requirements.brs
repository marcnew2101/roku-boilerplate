function setRequirements(params as boolean) as boolean
	requirements = createRequirements()
	if (params and requirements <> invalid)
		return checkRequirements(requirements)
	end if
	return true
end function
function createRequirements() as object
	requirementsFile = ReadAsciiFile("pkg:/components/data/requirements.json")
	if (requirementsFile <> invalid)
		json = ParseJson(requirementsFile)
		if (json <> invalid)
			return json
		end if
	end if
	return invalid
end function
function checkRequirements(requirements as object) as boolean
	for each requirement in requirements.items()
		if (requirement.value <> invalid and requirement.value["required"])
			deviceReady = getRequirement(requirement)
			if (deviceReady <> invalid)
				if (not deviceReady and requirement.value["error"])
					meetsRequirements = false
					m.top.error = requirement.key
				end if
			else
				exit for
			end if
		end if
	end for
	return deviceReady
end function
function getRequirement(requirement as object) as boolean
	v = m.global[requirement.key]
	if (v = invalid)
		return false
	else if (type(v) = "roBoolean")
		return v
	else
		return setAsBool(requirement, v)
	end if
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
	return false
end function
function getModel(requirement as object, model as string) as boolean
	for each legacyModel in requirement.value["legacyModels"]
		if (model = legacyModel)
			return false
			exit for
		end if
	end for
	return true
end function