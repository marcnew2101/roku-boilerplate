# Roku Boilerplate
_A starting point for new Roku applications._



## Features
- [X] Preset globals
- [X] Theme customization
- [X] Node management + history + focus
- [X] Translations
- [X] Pop-up dialogs
- [ ] Testing (Not yet implemented)


 ## Requirements
 * A Roku device with a minimum OS version of 9.4**

    ** _earlier OS versions may not compile due to deprecated libraries_

 * [Developer mode enabled](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md)


 ## Installation
 * This project uses the [VSCode](https://code.visualstudio.com/) IDE along with the [BrightScript Language Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript) for packaging and deploying builds.
 * Clone the repository to your preferred folder
 * Rename the ".env_sample" file to ".env". This file is located at the root of the project folder.
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


## Configuration
### Globals
Roku uses "m.global" to reference an object as seen in [/source/Main.brs](/source/Main.brs)

![Screenshot](/docs/images/globals.png)

* Global object values can be accessed from anywhere in the app.
    * m.global.ui could return a value of "HD" or "FHD". This would be useful in determing the background poster size to load from a remote image source (HD = 1280 x 720, FHD = 1920 x 1080)
    * 4 of the global object keys (model, os, internet, hdcp) are used with [/components/data/requirements.json](/components/data/requirements.json) to determine app eligibility at startup. See Requirements for more info.

<br/><br/>
### Themes
The root SceneGraph node in Roku (/components/HomeScene.xml) contains a palette field for customizing colors in child nodes.
 * Themes are set from the top of [/components/HomeScene.brs](/components/HomeScene.brs)
 > "dark" and "red" is the default theme here if no 2nd arugument is provided.
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

<br/><br/>
### Node Management
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
removeScreen(Node or "screenId")
```

Additional arguments can be used as follows:
```
removeScreen(
   screen           ' the child node itself or the ID of the child node
   showPrevScreen   ' shows the previous screen (true by default)
   removeFromStack  ' removes the node from the history stack (true by default)
)
```

#### Note
In order to use the node management library, each XML file requires a top level script assigned as follows:
```
<script type="text/brightscript" uri="pkg:/components/utils/Screens.brs" />
```
> also see [/components/screens/landing/LandingScreen.xml](/components/screens/landing/LandingScreen.xml)

<br/><br/>
### Translations
* The language translation folders are located at [/locale](/locale)
* Each folder is named according to the locale ID (see [Roku localization docs](https://developer.roku.com/docs/references/brightscript/interfaces/ifdeviceinfo.md#getcurrentlocale-as-string) for list of ID's)
* The files in each folder use the XLIFF format
* additional folders and translations can be added by following the format above

<br/><br/>
### Dialogs & Messages
A pop-up message or notification can be generated as follows:
```
setMessage("message")
```
The string passed to setMessage is assigned using data from [/components/data/messages.json](/components/data/messages.json):
> buttons are limited to the ones listed here. This can be further customized in `onButtonSelected()` at [/components/screens/dialogs/DialogModal.brs](/components/screens/dialogs/DialogModal.brs)
```
{
   "message": {
      "title": "title at top of dialog window",
      "message": "text inside body of dialog window",
      "help": [
         "bullet points that appear as helper text below the message body",
         "help is optional and can be an empty array if not needed"
      ],
      "buttons": [
         "OKAY",
         "CANCEL",
         "YES",
         "NO"
      ],
      "exitApp": set to true if the message requires the app to exit (such as failing to pass a requirement),
      "allowBack": set to true to allow pressing the back button on the remote to exit the dialog window
   }
}
```
#### Note
In order to use the dialog and messages library, each XML file requires a top level script assigned as follows:
```
<script type="text/brightscript" uri="pkg:/components/utils/Messages.brs" />
```

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
