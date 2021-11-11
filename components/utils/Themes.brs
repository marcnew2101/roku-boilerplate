sub getTheme(theme)
    ' check if the OS version is set globally and is at least version 9.4
    if (m.global.os <> Invalid AND m.global.os >= 9.4)
        ' create initial palette Node
        paletteNode = CreateObject("roSGNode", "RSGPalette")
        ' get the theme colors and background
        themeColors = setTheme(theme)
        ' check that themeColors is not invalid
        if (themeColors <> Invalid)
            ' get the top parent HomeScene node
            homeScene = m.top.getScene()
            ' set theme specific colors for the app if not invalid and object is not empty
            if (themeColors.palette <> Invalid AND themeColors.count() > 0)
                ' assign the color theme to the palette node
                paletteNode.colors = themeColors.palette
                ' set palette to HomeScene node
                homeScene.palette = paletteNode
            end if
            ' set theme specific background colors for the app if not invalid and object is not empty
            if (themeColors.bgURI <> Invalid AND len(themeColors.bgURI))
                ' set background URI to HomeScene node
                homeScene.backgroundURI = themeColors.bgURI
            else if (themeColors.bgColor <> Invalid AND len(themeColors.bgColor))
                ' HomeScene prioritizes using a URI image over a solid color. This will ensure the background color appears by disabling the backgroundURI field
                homeScene.backgroundURI = ""
                ' set background color to HomeScene node
                homeScene.backgroundColor = themeColors.bgColor
            end if
        end if
    end if
end sub

function setTheme(theme)
    ' empty AA for setting colors
    palette = {}
    ' create empty strings for setting background color or image URI
    bgColor = ""
    bgURI = ""

    ' check if theme is set to dark red
    if (theme = "dark-red")
        ' set the background color for the app
        bgColor = "0x0A0A0BFF"
        ' set the background image for the app
        bgURI = ""
        ' set colors for palette
        palette.PrimaryTextColor = "0xFFFFFFFF" ' white
        palette.SecondaryTextColor = "0xBEBABAFF" ' light gray
        palette.InputFieldColor = "0x000000FF" ' black
        palette.DialogBackgroundColor = "0x373737FF" ' dark gray
        palette.DialogItemColor = "0xFF0000FF" ' red
        palette.DialogTextColor = "0xFFFFFFFF" ' white
        palette.DialogBulletTextColor = "0xBEBABAFF" ' light gray
        palette.DialogFocusColor = "0xA60000FF" ' dark red
        palette.DialogFocusItemColor = "0xFFFFFFFF" ' white
        palette.DialogSecondaryTextColor = "0xBEBABAFF" ' light gray
        palette.DialogSecondaryItemColor = "0xFFFFFFFF" ' white
        palette.DialogInputFieldColor = "0xFFFFFFFF" ' white
        palette.DialogKeyboardColor = "0xFFFFFFFF" ' white
        palette.DialogFootprintColor = "0xFFFFFFFF" ' white

    ' check if theme is set to light red
    else if (theme = "light-red")
        ' set the background color for the app
        bgColor = "0x0A0A0BFF"
        ' set the background image for the app
        bgURI = ""
        ' set colors for palette
        palette.PrimaryTextColor = "0x000000FF" ' black
        palette.SecondaryTextColor = "0x373737FF" ' dark gray
        palette.InputFieldColor = "0xFFFFFFFF" ' white
        palette.DialogBackgroundColor = "0xEBEBEBFF" ' white
        palette.DialogItemColor = "0x10AEFEFF" ' blue
        palette.DialogTextColor = "0x000000FF" ' black
        palette.DialogBulletTextColor = "0x373737FF" ' dark gray
        palette.DialogFocusColor = "0xA60000FF" ' dark red
        palette.DialogFocusItemColor = "0xFFFFFFFF" ' white
        palette.DialogSecondaryTextColor = "0x373737FF" ' dark gray
        palette.DialogSecondaryItemColor = "0x373737FF" ' dark gray
        palette.DialogInputFieldColor = "0xFFFFFFFF" ' white
        palette.DialogKeyboardColor = "0xFFFFFFFF" ' white
        palette.DialogFootprintColor = "0xFFFFFFFF" ' white
    end if

    return {"palette": palette, "bgColor": bgColor, "bgURI": bgURI} 
end function