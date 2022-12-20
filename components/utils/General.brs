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
sub initConfiguration(setConfig as boolean, node = m.top.getScene() as object)
    if (setConfig)
        logging("getting configuration...")
        try
            logging("loading configuration file...")
            ' get configuration file
            config = parseJson(readAsciiFile("pkg:/components/data/config.json"))
            ' set interface field on HomeScene node
            node.setField("config", config)
            if not isNullOrEmpty(config.debugFlags)
                if config.debugFlags.printDeviceInfo then showDeviceInfo()
                if config.debugFlags.printAppInfo then showAppInfo()
            end if
        catch e
            logging("unable to read config.json file - " + e.message, 3)
        end try
    end if
end sub
sub initMenuContent(menuType as string, config = m.top.getScene().config as object) as object
    menu = createObject("roSGNode", "ContentNode")
    if (not isNullOrEmpty(menuType) and not isNullOrEmpty(config))
        logging("getting menu for " + menuType)
        try
            logging("loading menus file...")
            ' get menus file
            menus = parseJson(readAsciiFile("pkg:/components/data/menus.json"))
            ' check for main (side) menu
            if not isNullOrEmpty(menus[menuType])
                for each item in menus[menuType]
                    if (not isNullOrEmpty(item.buildType) and arrayContains(item.buildType, config.buildType))
                        menuItem = createObject("roSGNode", "MenuItem")
                        menuItem.id = item.id
                        menuItem.title = tr(item.title)
                        menuItem.iconUri = "pkg:/images/menu/icon_" + menuItem.id + ".png"
                        menuItem.focusedIconUri = "pkg:/images/menu/icon_focused_" + menuItem.id + ".png"
                        menu.appendChild(menuItem)
                    end if
                end for
            end if
        catch e
            logging("unable to read menus.json file - " + e.message, 3)
        end try
    end if
    return menu
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
sub exitApp(confirm = true, node = m.top.getScene())
    if (confirm)
        node.message = "exit"
    else
        node.exitApp = true
    end if
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
function aaContains(aa as object, key as string, parseTree = true as boolean) as boolean
    if (isAA(aa) and not isNullOrEmpty(key))
        keyExists = aa.doesExist(key)
        if keyExists then return true
        for each item in aa.items()
            if (isAA(item.value) and parseTree)
                keyFound = aaContains(item.value, key, parseTree)
                if keyFound then return true
            end if
        end for
    end if
    return false
end function
function getAAValue(aa as object, key as string, parseTree = true as boolean) as dynamic
    if (isAA(aa) and not isNullOrEmpty(key))
        keyExists = aa.lookUp(key)
        if keyExists <> invalid then return keyExists
        for each item in aa.items()
            if (isAA(item.value) and parseTree)
                keyFound = getAAValue(item.value, key, parseTree)
                if keyFound <> invalid then return keyFound
            end if
        end for
    end if
    return invalid
end function
function stringToBool(value as string) as boolean
	if (value <> invalid and value.len() > 0)
		return lCase(value) = "true"
	end if
	return false
end function