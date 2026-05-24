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

' ---- Roku certification beacons ----
sub dialogInit(node = m.scene)
    ' Roku certification requires this to indicate a modal requires the users attention
    if not node.appLoaded
        node.signalBeacon(Const().beacon.dialogInitiate)
    end if
end sub

sub dialogComplete(node = m.scene)
    ' Roku certification requires this to indicate the modal is closed
    if not node.appLoaded
        node.signalBeacon(Const().beacon.dialogComplete)
    end if
end sub

sub appLoaded(node = m.scene)
    if not node.appLoaded
        node.appLoaded = true
        ' Roku certification requires this to indicate the app is finished loading
        node.signalBeacon(Const().beacon.launchComplete)
    end if
end sub