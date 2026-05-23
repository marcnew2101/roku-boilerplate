sub setTheme(args as boolean, theme = { "type": "dark", "color": "red" } as object)
    if not args then return
    prevTheme = getThemeFromRegistry()
    if prevTheme <> invalid then theme = prevTheme
    themeColors = getTheme(theme)
    if themeColors = invalid then return
    homeScene = m.top.getScene()
    if themeColors.palette <> invalid and themeColors.palette.count() > 0
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        paletteNode.colors = themeColors.palette
        homeScene.palette = paletteNode
    end if
    if themeColors.backgroundUri <> invalid then homeScene.backgroundUri = themeColors.backgroundUri
    if themeColors.backgroundColor <> invalid then homeScene.backgroundColor = themeColors.backgroundColor
    if themeColors.selectorUri <> invalid and len(themeColors.selectorUri) > 0 then homeScene.selectorUri = themeColors.selectorUri
end sub
function getThemeFromRegistry() as object
    ' set theme to initial state
    theme = invalid
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
    themefile = ReadAsciiFile("pkg:/components/data/themes.json")
    if themefile = invalid then return invalid
    json = ParseJson(themefile)
    if json = invalid then return invalid
    themeType = json[theme.type]
    if themeType = invalid or themeType.count() = 0 then return invalid
    for each color in themeType
        if color[theme.color] <> invalid then return color[theme.color]
    end for
    return invalid
end function