' Returns the root Scene node from any component, so util scripts can call
' scene().X without each component caching m.scene in init().
function scene() as object
    return m.top.getScene()
end function

' hasValue: non-invalid + non-empty for strings/arrays/AAs; always-true for booleans/numbers/nodes.
' Don't use valueOr() to default booleans — see README for the caveat.
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