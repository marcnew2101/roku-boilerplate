# Roku Boilerplate
_A starting point for new Roku applications._



## Features
- [X] Preset globals
- [X] Theme customization
- [X] Node management + history + focus
- [X] BaseScreen with lifecycle hooks (`onScreenVisible` / `onScreenHidden`)
- [X] Centralized constants via `Const()`
- [X] Leveled logging via `logError` / `logWarn` / `logInfo` / `logDebug`
- [X] Translations
- [X] Pop-up dialogs
- [ ] Testing (Not yet implemented)


 ## Requirements
 * A Roku device with a minimum OS version of 10.0**

    ** _enforced at startup by [/components/data/requirements.json](/components/data/requirements.json); earlier OS versions may also fail to compile due to deprecated libraries_

 * [Developer mode enabled](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md)


 ## Installation
 * This project uses the [VSCode](https://code.visualstudio.com/) IDE along with the [BrightScript Language Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript) for packaging and deploying builds.
 * Clone the repository to your preferred folder
 * Rename the ".env-sample" file to ".env". This file is located at the root of the project folder.
    * ROKU_HOST = your Roku device IP address
    * ROKU_USERNAME = "rokudev" (default)
    * ROKU_PASSWORD = the password you set when enabling developer mode


## Deployment
ZIP file is automatically generated in /out/roku-deploy.zip and sent to your Roku device:
* Windows, press F5
* MacOS, press Fn + F5


## Console & Debugging
* The OUTPUT and DEBUG CONSOLE within VSCode will show the app activity as well as any print commands.
    * Enabling (true) "showDeviceInfo" and/or "showAppInfo" at the top of [/source/Main.brs](/source/Main.brs) will print information about the device to the console.
* If the app closes, the console/debug session will automatically close

### Logging
Use the leveled helpers in [/components/utils/Logger.brs](/components/utils/Logger.brs) instead of inline `?` statements:
```
logError("something failed", "Source.brs")
logWarn("deeplink missing mediaType")
logInfo("App loaded")
logDebug("up key pressed", "LandingScreen.brs")
```
Output format: `[LEVEL] message  (Source.brs)`. The source argument is optional but useful for grep.

| Level | When printed |
|---|---|
| `logError` | Always (prefixed with a blank line) |
| `logWarn` | Always |
| `logInfo` | Only when `m.global.devLogging` is true |
| `logDebug` | Only when `m.global.devLogging` is true |

`devLogging` is declared at the top of [/source/Main.brs](/source/Main.brs) alongside `showDeviceInfo` / `showAppInfo` / `showBandwidth` / `showHttpErrors`. Set it to `false` for a quieter production build.


## Configuration
### Globals
Roku uses "m.global" to reference an object as seen in [/source/Main.brs](/source/Main.brs)

![Screenshot](/docs/images/globals.png)

* Global object values can be accessed from anywhere in the app.
    * `m.global.ui` could return a value of "HD" or "FHD". This is useful when picking remote image sizes (HD = 1280 x 720, FHD = 1920 x 1080).
    * 4 of the keys (`model`, `os`, `internet`, `hdcp`) are used with [/components/data/requirements.json](/components/data/requirements.json) to determine app eligibility at startup. See Requirements for more info.
    * `deeplink` is set from the launch args (`contentId` / `mediaType`) when present. See `getDeepLinks` in [/source/Main.brs](/source/Main.brs).
    * `devLogging` controls whether `logInfo` / `logDebug` output is printed. See Logging.

<br/><br/>
### Themes
Roku's Scene node exposes a `palette` field for theming colors in child nodes; this template applies the selected theme onto `m.scene` at startup.
 * Themes are set from the top of [/components/HomeScene.brs](/components/HomeScene.brs)
 > "dark" and "red" is the default theme here if no 2nd argument is provided.
 ```
 setTheme(true, { "type": "dark", "color": "red" })
 ```
 * The palette colors, background colors and selectors can be customized in [/components/data/themes.json](/components/data/themes.json) 
    * themes are defined using the following format:
 ```
 {
    "dark": [
        {
            "color": {}
        }
    ],
    "light": [
        {
            "color": {}
        }
    ]
}
 ```
 * Read theme values via the `theme()` accessor (from [/components/utils/Themes.brs](/components/utils/Themes.brs)):
 ```
 m.label.color = theme().colors.primaryTextColor   ' palette color
 m.list.focusBitmapUri = theme().selectorUri       ' scene-level theme field
 ```
 > Palette colors live under `theme().colors`; scene-level theme fields (`backgroundColor`, `backgroundUri`, `selectorUri`) are at the top level.

<br/><br/>
### Constants
Magic strings and numbers (key codes, file paths, registry section, beacon names, dialog typography) live in [/components/utils/Constants.brs](/components/utils/Constants.brs) as an AA returned by `Const()`:
```
key = Const().key.back                          ' "back"
ReadAsciiFile(Const().path.messages)            ' "pkg:/components/data/messages.json"
node.signalBeacon(Const().beacon.launchComplete)
fontSize = Const().dialog.messageFontSize       ' 32
```
Add new groups to `Const()` rather than introducing new literals in call sites. See [/components/utils/Constants.brs](/components/utils/Constants.brs) for the full table.

<br/><br/>
### Node Management
#### Screen Lifecycle Hooks
Any screen that extends `BaseScreen` must define its own `init()` and call `baseScreenInit()` as the first line — that caches `m.scene`, hides the screen until shown, and wires the visibility observer. After that, set up node refs and field observers as usual:
```
sub init()
    baseScreenInit()
    m.myList = m.top.findNode("myList")
    m.myList.observeField("itemSelected", "onItemSelected")
end sub
```
Two optional hooks fire when the screen's `visible` field changes — override either by redeclaring it in the screen's `.brs`:
```
sub onScreenVisible()
    ' run every time the screen becomes visible — fetch data, set focus, etc.
end sub
sub onScreenHidden()
    ' run every time the screen is hidden — pause animations, cancel requests, etc.
end sub
```
> Each hook is a no-op by default. Implementing one in a subclass overrides the parent's no-op since SceneGraph loads child scripts after the parent's.
> See [/components/screens/landing/LandingScreen.brs](/components/screens/landing/LandingScreen.brs) for a working example.

`BaseScreen` also declares a `focusedNode` field on its interface, used by `setFocus(node, saveFocus)` to remember which child node was last focused — see Setting screen focus below.

#### Adding a new node to the root scene node:
> If "screenId" is not set, the "screenName" will be used as the node ID. If the ID is already being used, a console warning will appear.
```
addScreen("screenName", "screenId")
```

Additional arguments can be used as follows:
```
addScreen(
   screenName     ' the name of the node/XML file
   screenId       ' the id to assign the node
   showScreen     ' sets the node visibility (true by default)
   hidePrevScreen ' hides the previous/current screen (true by default), 
   addToStack     ' adds the node to the history stack (true by default)
)
```

#### Finding an existing node:
> If multiple child nodes share the same ID, this will return the one that was created first.
```
getScreen("screenId")
```

Additional arguments can be used as follows:
```
getScreen(
   screenId    ' the id of the existing node
   showScreen  ' set the node visibility to true (false by default)
)
```

#### Removing a node from the root scene:
> Pass the child node, such as "m.top", or use the ID of the node you want to remove
```
removeScreen(node or "screenId")
```

Additional arguments can be used as follows:
```
removeScreen(
   screen           ' the child node itself or the ID of the child node
   showPrevScreen   ' shows the previous screen (true by default)
   removeFromStack  ' removes the node from the history stack (true by default)
)
```

#### Setting screen focus
> Pass the node to assign focus or the node ID of the node to assign focus to
```
setFocus(node or node ID)
```
Additional arguments can be used as follows:
```
setFocus(
   node        ' the node or the node ID
   saveFocus   ' writes the focused node to m.top's focusedNode field (true by default)
)
```
> `focusedNode` is declared on the `BaseScreen` interface. When a BaseScreen-derived screen becomes visible again after being hidden, `removeHistory` reads this field and re-focuses the saved node.


#### Note
Screens extending `BaseScreen` automatically inherit every utility script (`Screens.brs`, `History.brs`, `Themes.brs`, `Messages.brs`, `Requirements.brs`, `General.brs`, `Constants.brs`, `Logger.brs`, `Debug.brs`) via the parent component's `<script>` tags — you don't need to re-include them. The only place to register new utilities is in [/components/screens/base/BaseScreen.xml](/components/screens/base/BaseScreen.xml) (and [/components/HomeScene.xml](/components/HomeScene.xml) if HomeScene also needs the utility).

> See [/components/screens/landing/LandingScreen.xml](/components/screens/landing/LandingScreen.xml) for a working example.

<br/><br/>
### Translations
* The language translation folders are located at [/locale](/locale)
* Each folder is named according to the locale ID (see [Roku localization docs](https://developer.roku.com/docs/references/brightscript/interfaces/ifdeviceinfo.md#getcurrentlocale-as-string) for list of ID's)
* The files in each folder use the XLIFF format
* additional folders and translations can be added by following the format above

<br/><br/>
### Dialogs & Messages
Show a dialog from a [/components/data/messages.json](/components/data/messages.json) entry by key:
```
showMessage("message")
```
Or pass a dialog config object directly to `showDialog(config)` (see [/components/utils/Messages.brs](/components/utils/Messages.brs)) when the dialog isn't backed by a JSON entry.

Entries in `messages.json` follow this schema:
```
{
   "message": {
      "title": "title at top of dialog window",
      "message": "text inside body of dialog window",
      "help": [
         "items shown below the message body",
         "help is optional and can be an empty array if not needed"
      ],
      "buttons": [
         { "label": "OKAY", "exitApp": true },
         { "label": "CANCEL" }
      ],
      "allowBack": set to true to allow pressing the back button on the remote to exit the dialog window
   }
}
```
Each button is an object with a required `label` and two optional fields:
- `exitApp: true` — sets `m.scene.exitApp` when pressed, breaking the main loop in [/source/Main.brs](/source/Main.brs)
- `onPress: { "node": nodeRef, "func": "funcName" }` — invokes `nodeRef.callFunc(funcName, { label, index })` when pressed

Buttons without `exitApp` dismiss the dialog after firing their `onPress` (if any). See `onButtonSelected` in [/components/screens/dialogs/DialogModal.brs](/components/screens/dialogs/DialogModal.brs).
<br/><br/>
## Resources
* Examples and other Roku libraries
    * [GitHub Roku Developers](https://github.com/rokudev)
* Help & Support
    * [Roku Developer Community Forum](https://community.roku.com/t5/Roku-Developer-Program/bd-p/roku-developer-program)
    * [Slack Channel](https://join.slack.com/t/rokudevelopers/shared_invite/enQtMzgyODg0ODY0NDM5LTM0N2UzYWExOGVlMTRlNGI2OTQ0ODA0Y2ZmMzFhZmMwMWEzNWI2MGM1YzFkZDVkZDNiNjYzYTgwODczNGQ2NDY)
* Docs & Tutorials:
    * [Getting Started](https://developer.roku.com/docs/developer-program/getting-started/roku-dev-prog.md)
    * [API Reference](https://developer.roku.com/docs/references/references-overview.md)
