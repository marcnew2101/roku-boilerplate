sub dialogInit(node = m.top.getScene())
    ' Roku certification requires this to indicate a modal requires the users attention
    if not node.appLoaded then node.signalBeacon("AppDialogInitiate")
end sub
sub dialogComplete(node = m.top.getScene())
    ' Roku certification requires this to indicate the modal is closed
    if not node.appLoaded then node.signalBeacon("AppDialogComplete")
end sub
sub appLoaded(node = m.top.getScene())
    if (not node.appLoaded)
        ' indicate that the app is now loaded
        node.appLoaded = true
        ' Roku certification requires this to indicate the app is finished loading
	    node.signalBeacon("AppLaunchComplete")
    end if
end sub