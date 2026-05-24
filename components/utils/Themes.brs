sub setTheme(args as boolean, theme = { "type": "dark", "color": "red" } as object)
    if not args then return
    prevTheme = getThemeFromRegistry()
    if prevTheme <> invalid then theme = prevTheme
    themeColors = getTheme(theme)
    if themeColors = invalid then return
    if hasValue(themeColors.palette)
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        paletteNode.colors = themeColors.palette
        m.scene.palette = paletteNode
    end if
    ' hasValue treats empty strings as absent, so "" in themes.json means "leave the default"
    if hasValue(themeColors.backgroundUri)
        m.scene.backgroundUri = themeColors.backgroundUri
    end if
    if hasValue(themeColors.backgroundColor)
        m.scene.backgroundColor = themeColors.backgroundColor
    end if
    if hasValue(themeColors.selectorUri)
        m.scene.selectorUri = themeColors.selectorUri
    end if
end sub

function getThemeFromRegistry() as object
    theme = invalid
    reg = createObject("roRegistrySection", Const().registry.theme)
    if reg.exists("type") and reg.exists("color")
        theme = reg.readMulti(["type", "color"])
    end if
    return theme
end function

function getTheme(theme as object) as dynamic
    themefile = ReadAsciiFile(Const().path.themes)
    if themefile = invalid then return invalid
    json = ParseJson(themefile)
    if json = invalid then return invalid
    themeType = json[theme.type]
    if not hasValue(themeType) then return invalid
    for each color in themeType
        if color[theme.color] <> invalid then return color[theme.color]
    end for
    return invalid
end function