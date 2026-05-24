' Roku certification beacons. Each beacon signals a lifecycle event the platform
' watches for during certification — dialogs that appear before AppLaunchComplete
' must be paired with dialogInit/dialogComplete; the launch itself signals appLoaded.

sub dialogInit(node = scene())
    ' Roku certification requires this to indicate a modal requires the users attention
    if not node.appLoaded
        node.signalBeacon(Const().beacon.dialogInitiate)
    end if
end sub

sub dialogComplete(node = scene())
    ' Roku certification requires this to indicate the modal is closed
    if not node.appLoaded
        node.signalBeacon(Const().beacon.dialogComplete)
    end if
end sub

sub appLoaded(node = scene())
    if not node.appLoaded
        node.appLoaded = true
        ' Roku certification requires this to indicate the app is finished loading
        node.signalBeacon(Const().beacon.launchComplete)
    end if
end sub
