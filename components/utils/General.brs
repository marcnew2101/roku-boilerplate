' ---- scene accessor ----
' Returns the root Scene node from any component. Lets util scripts call scene().X
' instead of requiring each component's init() to cache m.scene = m.top.getScene().
function scene() as object
    return m.top.getScene()
end function

' ---- value helpers ----
' true when x is non-invalid and (for strings / arrays / AAs) non-empty.
' Numbers, booleans, and nodes only get the non-invalid check, so hasValue(false)
' and hasValue(0) both return true. Don't use valueOr() to default booleans:
' false is "present" and the default never fires.
function hasValue(x as dynamic) as boolean
    if x = invalid then return false
    valueType = type(x)
    if valueType = "String" or valueType = "roString" then return len(x) > 0
    if valueType = "roArray" or valueType = "roAssociativeArray" then return x.count() > 0
    return true
end function

function valueOr(x as dynamic, defaultValue as dynamic) as dynamic
    if hasValue(x) then return x
    return defaultValue
end function