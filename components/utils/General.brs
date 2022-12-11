sub dialogInit(node = m.top.getScene() as object)
    ' Roku certification requires this to indicate a modal requires the users attention
    if not node.appLoaded then node.signalBeacon("AppDialogInitiate")
end sub
sub dialogComplete(node = m.top.getScene() as object)
    ' Roku certification requires this to indicate the modal is closed
    if not node.appLoaded then node.signalBeacon("AppDialogComplete")
end sub
sub appLoaded(node = m.top.getScene() as object)
    if (not node.appLoaded)
        ' indicate that the app is now loaded
        node.appLoaded = true
        ' Roku certification requires this to indicate the app is finished loading
	    node.signalBeacon("AppLaunchComplete")
    end if
end sub
sub initGlobals()
    m.global.addFields({
		"debug": false,
		"debugLevel": 0
	})
end sub
sub initConfiguration(setConfig as boolean, node = m.top.getScene() as object)
    if (setConfig)
        logging("getting configuration...", 0, true, true)
        try
            logging("loading configuration file...", 0, true, true)
            ' get configuration file
            config = parseJson(readAsciiFile("pkg:/components/data/config.json"))
            ' set interface field on HomeScene node
            node.setField("config", config)
            if not isNullOrEmpty(config.buildType) and config.buildType = "debug" then m.global.debug = true
            if not isNullOrEmpty(config.debugLevel) and config.debugLevel >= 0 then m.global.debugLevel = config.debugLevel
            if not isNullOrEmpty(config.debugFlags)
                if config.debugFlags.showDeviceInfo then showDeviceInfo()
                if config.debugFlags.showAppInfo then showAppInfo()
            end if
        catch e
            logging("unable to read config.json file - " + e.message, 3, true, true)
        end try
    end if
end sub
sub initMenuContent(config = m.top.getScene().config as object)
    if (not isNullOrEmpty(config.menu))
        logging("getting menu content...")
        menuItems = []
        for each item in config.menu
            if (not isNullOrEmpty(item.appState) and arrayContains(item, config.buildType))
                menuItem = createObject("roSGNode", "MenuItem")
                menuItem.id = item.id
                menuItem.title = item.title
                menuItem.iconUri = "pkg:/images/menu/icon_" + menuItem.id + ".png"
                menuItem.focusedIconUri = "pkg:/images/menu/icon_focused_" + menuItem.id + ".png"
                menuItems.push(menuItem)
            end if
        end for
    end if
end sub
function isNullOrEmpty(value as dynamic) as boolean
    if (isString(value))
        return (value = invalid or value = "")
    else if (isArray(value) or isAA(value))
        return (value = invalid or value.count() = 0)
    else if isNode(value)
        return (value = invalid or value.getChildCount() = 0)
    else
        return not isValid(value)
    end if
end function
function iffy(condition as boolean, this as dynamic, that as dynamic) as dynamic
    if condition then
        return this
    else
        return that
    end if
end function
sub exitApp(node = m.top.getScene())
    node.exitApp = true
end sub
function arrayContains(array as object, value as dynamic) as boolean
    if (not isNullOrEmpty(array) and not isNullOrEmpty(value) and isArray(array))
        for each item in array
            if (item = value)
                return true
            end if
        end for
    end if
    return false
end function
function aaContains(aa as object, key as string, parseTree = false as boolean, getReturnValue = false as boolean) as dynamic
    if (isAA(aa) and not isNullOrEmpty(key))
        keyExists = aa.lookUp(key)
        if (keyExists <> invalid)
            if getReturnValue then return keyExists else return true
        end if
        for each item in aa.items()
            if (isAA(item.value) and parseTree)
                result = aaContains(item.value, key, parseTree, getReturnValue)
                if (result <> invalid)
                    if getReturnValue then return result else return true
                end if
            end if
        end for
    end if
    if not getReturnValue then return false else return invalid
end function