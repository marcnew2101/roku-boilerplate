sub setTheme(enabled as boolean, themeChoice = { "type": "dark", "color": "red" } as object)
    if not enabled then return
    prevTheme = getThemeFromRegistry()
    if prevTheme <> invalid then themeChoice = prevTheme
    themeColors = getTheme(themeChoice)
    if themeColors = invalid then return

    if hasValue(themeColors.palette)
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        paletteNode.colors = themeColors.palette
        scene().palette = paletteNode
    end if
    ' hasValue treats empty strings as absent, so "" in themes.json means "leave the default"
    if hasValue(themeColors.backgroundUri)
        scene().backgroundUri = themeColors.backgroundUri
    end if
    if hasValue(themeColors.backgroundColor)
        scene().backgroundColor = themeColors.backgroundColor
    end if
    if hasValue(themeColors.selectorUri)
        scene().selectorUri = themeColors.selectorUri
    end if
end sub

function theme() as object
    return {
        colors: scene().palette.colors,
        backgroundColor: scene().backgroundColor,
        backgroundUri: scene().backgroundUri,
        selectorUri: scene().selectorUri
    }
end function

function getThemeFromRegistry() as object
    themeChoice = invalid
    reg = createObject("roRegistrySection", Const().registry.theme)
    if reg.exists("type") and reg.exists("color")
        themeChoice = reg.readMulti(["type", "color"])
    end if
    return themeChoice
end function

function getTheme(themeChoice as object) as dynamic
    themefile = ReadAsciiFile(Const().path.themes)
    if themefile = invalid then return invalid
    json = ParseJson(themefile)
    if json = invalid then return invalid

    themeType = json[themeChoice.type]
    if not hasValue(themeType) then return invalid
    for each color in themeType
        if color[themeChoice.color] <> invalid then return color[themeChoice.color]
    end for
    return invalid
end function