sub dialogInit(node = m.top.getScene())
    ' Roku certification requires this to indicate a modal requires the users attention
    if not node.appLoaded then node.signalBeacon(Const().beacon.dialogInitiate)
end sub
sub dialogComplete(node = m.top.getScene())
    ' Roku certification requires this to indicate the modal is closed
    if not node.appLoaded then node.signalBeacon(Const().beacon.dialogComplete)
end sub
sub appLoaded(node = m.top.getScene())
    if not node.appLoaded
        node.appLoaded = true
        ' Roku certification requires this to indicate the app is finished loading
        node.signalBeacon(Const().beacon.launchComplete)
    end if
end sub