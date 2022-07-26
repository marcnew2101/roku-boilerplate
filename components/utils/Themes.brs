sub setTheme(params as boolean)
    ' check if theme is true
    if (params)
        ' set default theme
        defaultTheme = { "type": "dark", "color": "red" }
        ' check if theme was previously set by user
        theme = getThemeFromRegistry(defaultTheme)
        ' create initial palette Node
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        ' get the theme colors and background
        themeColors = getTheme(theme)
        ' check that themeColors is not invalid
        if (themeColors <> invalid)
            ' get the top parent HomeScene node
            homeScene = m.top.getScene()
            ' set theme specific colors for the app if not invalid and object is not empty
            if (themeColors.palette <> invalid and themeColors.palette.count() > 0)
                ' assign the color theme to the palette node
                paletteNode.colors = themeColors.palette
                ' set palette to HomeScene node
                homeScene.palette = paletteNode
            end if
            ' set theme specific background image URI for the app if valid and string is not empty
            if (themeColors.backgroundURI <> invalid and len(themeColors.backgroundURI) > 0)
                ' set background URI to HomeScene node
                homeScene.backgroundURI = themeColors.backgroundURI
            end if
            ' set theme specific background color for the app if valid and string is not empty
            if (themeColors.backgroundColor <> invalid and len(themeColors.backgroundColor) > 0)
                ' set background color to HomeScene node
                homeScene.backgroundColor = themeColors.backgroundColor
            end if
            ' set theme specific selector for rows/grids/lists if valid and string is not empty
            if (themeColors.selectorURI <> invalid and len(themeColors.selectorURI) > 0)
                ' set selector URI to HomeScene node
                homeScene.selectorURI = themeColors.selectorURI
            end if
        end if
    end if
end sub

function getThemeFromRegistry(theme as object) as object
    ' create registry section
    reg = createObject("roRegistrySection", "theme")
    ' check that keys exist in the registry
    if (reg.exists("type") and reg.exists("color"))
        ' set theme to object from registry
        theme = reg.readMulti(["type", "color"])
    end if
    return theme
end function

function getTheme(theme as object) as dynamic
    ' get json file from local storage
    themefile = ReadAsciiFile("pkg:/components/data/themes.json")
    ' check that file exists
    if (themefile <> invalid)
        ' convert file to readable json
        json = ParseJson(themefile)
        ' check that json is valid
        if (json <> invalid)
            ' get dark or light theme (array)
            themeType = json[theme.type]
            ' check that theme array is valid and contains at least one entry
            if (themeType <> invalid and themeType.count() > 0)
                ' loop over color AA in theme array
                for each color in themeType
                    ' check that theme color exists (object)
                    if (color[theme.color] <> invalid)
                        ' return color object
                        return color
                        ' exit for loop
                        exit for
                    end if
                end for
            end if
        end if
    end if
    return invalid
end function