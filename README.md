# Roku Boilerplate
_A starting point for new Roku applications._



## Features
* Preset globals
* Theme customization
* Node management + history + focus
* Translations
* Pop-up dialogs
* Testing (Not yet implemented)



## Resources
* Examples and other Roku libraries
    * [GitHub Roku Developers](https://github.com/rokudev)
* Help & Support
    * [Roku Developer Community Forum](https://community.roku.com/t5/Roku-Developer-Program/bd-p/roku-developer-program)
    * [Slack Channel](https://join.slack.com/t/rokudevelopers/shared_invite/enQtMzgyODg0ODY0NDM5LTM0N2UzYWExOGVlMTRlNGI2OTQ0ODA0Y2ZmMzFhZmMwMWEzNWI2MGM1YzFkZDVkZDNiNjYzYTgwODczNGQ2NDY)
* Docs & Tutorials:
    * [Getting Started](https://developer.roku.com/docs/developer-program/getting-started/roku-dev-prog.md)
    * [API Reference](https://developer.roku.com/docs/references/references-overview.md)


 ## Requirements
 * A Roku device with a minimum OS version of 9.4**

    ** _earlier OS versions may not compile due to deprecated libraries_

 * [Developer mode enabled](https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md)


 ## Installation
 * This project uses the [VSCode](https://code.visualstudio.com/) IDE along with the [BrightScript Language Extension](https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript) for packaging and deploying builds.
 * Clone the repository to your preferred folder


 ## Configuration
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


### Globals
Roku uses "m.global" to reference an object as seen in [/source/Main.brs](/source/Main.brs)

![Screenshot](/docs/images/globals.png)

* Global object values can be accessed from anywhere in the app.
    * m.global.ui could return a value of "HD" or "FHD". This would be useful in determing the background poster size to load from a remote image source (HD = 1280 x 720, FHD = 1920 x 1080)
    * 4 of the global object keys (model, os, internet, hdcp) are used with [/components/data/requirements.json](/components/data/requirements.json) to determine app eligibility at startup. See Requirements for more info.


### Themes
The root SceneGraph node in Roku (/components/HomeScene.xml) contains a palette field for customizing colors in child nodes.
 * Themes are set from /components/HomeScene.brs
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
