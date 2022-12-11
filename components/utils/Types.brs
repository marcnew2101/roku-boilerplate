function isString(value as dynamic) as boolean
    return isValid(value) and getInterface(value, "ifString") <> invalid
end function
function isBoolean(value as dynamic) as boolean
    return isValid(value) and getInterface(value, "ifBoolean") <> invalid
end function
function isArray(value as dynamic) as boolean
    return isValid(value) and getInterface(value, "ifArray") <> invalid
end function
function isAA(value as dynamic) as boolean
    return isValid(value) and getInterface(value, "ifAssociativeArray") <> invalid
end function
function isNode(value as dynamic) as boolean
    return isValid(value) and getInterface(value, "ifSGNodeField") <> invalid
end function
function isValid(value as dynamic) as boolean
    return type(value) <> "<uninitialized>" and value <> invalid
end function