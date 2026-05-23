sub setTheme(args as boolean, theme = { "type": "dark", "color": "red" } as object)
    if not args then return
    prevTheme = getThemeFromRegistry()
    if prevTheme <> invalid then theme = prevTheme
    themeColors = getTheme(theme)
    if themeColors = invalid then return
    homeScene = m.top.getScene()
    if hasValue(themeColors.palette)
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        paletteNode.colors = themeColors.palette
        homeScene.palette = paletteNode
    end if
    if themeColors.backgroundUri <> invalid
        homeScene.backgroundUri = themeColors.backgroundUri
    end if
    if themeColors.backgroundColor <> invalid
        homeScene.backgroundColor = themeColors.backgroundColor
    end if
    if hasValue(themeColors.selectorUri)
        homeScene.selectorUri = themeColors.selectorUri
    end if
end sub
function getThemeFromRegistry() as object
    theme = invalid
    reg = createObject("roRegistrySection", Const().registry.theme)
    if reg.exists("type") and reg.exists("color") then theme = reg.readMulti(["type", "color"])
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