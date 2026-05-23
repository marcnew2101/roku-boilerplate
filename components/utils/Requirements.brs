function setRequirements(params as boolean) as boolean
    requirements = createRequirements()
    if (params and requirements <> invalid)
        return checkRequirements(requirements)
    end if
    return true
end function

function createRequirements() as object
    requirementsFile = ReadAsciiFile(Const().path.requirements)
    if requirementsFile = invalid then return invalid
    json = ParseJson(requirementsFile)
    if json = invalid then return invalid
    return json
end function

function checkRequirements(requirements as object) as boolean
    ' default to ready so empty or all-optional requirement sets pass the type contract
    deviceReady = true
    for each requirement in requirements.items()
        if requirement.value = invalid or requirement.value["required"] <> true then continue for
        passed = getRequirement(requirement)
        ' AND so any failed required check sticks; a later passing check can't unmask it
        deviceReady = deviceReady and passed
        if not passed and requirement.value["showError"] = true
            m.scene.message = requirement.key
            exit for
        end if
    end for
    return deviceReady
end function

function getRequirement(requirement as object) as boolean
    v = m.global[requirement.key]
    if v = invalid then return false
    if type(v) = "roBoolean" then return v
    return setAsBool(requirement, v)
end function

function setAsBool(requirement as object, v as dynamic) as boolean
    if requirement.key = "os" then return getMinOS(requirement, v)
    if requirement.key = "model" then return getModel(requirement, v)
    ' fail closed on unknown keys so a misnamed requirement doesn't silently pass
    logWarn("unknown non-boolean requirement key: " + requirement.key, "Requirements.brs")
    return false
end function

function getMinOS(requirement as object, os as float) as boolean
    return os >= requirement.value["minVersion"]
end function

function getModel(requirement as object, model as string) as boolean
    for each legacyModel in requirement.value["legacyModels"]
        if (model = legacyModel)
            return false
        end if
    end for
    return true
end function