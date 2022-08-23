# roku-boilerplate
A basic starting point for creating new Roku/Brightscript projects. This project is in no way affiliated with Roku or its subsidaries.

## preface
 - An understanding of the Roku language and framework is not required. While Roku's Brightscript language and SceneGraph framework is not as popular as other programming languages and frameworks, there are a multitude of sample files developed by the community that can be found here - https://github.com/rokudev/samples
 - You can also search for and ask questions over at the Roku developer forum - https://community.roku.com/t5/Roku-Developer-Program/bd-p/roku-developer-program
 - Docs are located here for reference - https://developer.roku.com/docs/references/references-overview.md

### requirements
 - A Roku streaming device
 - Developer mode enabled (https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md)
 - The Roku device must share the same network/subnet as the computer you are using to develop the app
 - A web browser

### plugins
This project requires the vscode-brightscript-language plugin. It can be added through the extensions library in vscode or from the marketplace at https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript.

### structure
The ".vscode/launch.json" file at the root of the project contains definitions for handling the folder structure and deployment of your app. If you create additional folders for your project, you must update the launch.json file ("files": ["..."]) so that the new folders are included in the deployment.

### pre-deployment
 - Begin by renaming the ".env_sample" file to ".env". This file is located at the root of the project folder
 - Replace "ROKU_HOST" with the IP address of your Roku device. The IP address can be found on the Roku menu screen:  Settings -> Network -> About
 - Replace "ROKU_PASSWORD" with the password you created when you first enabled developer mode on your Roku device. If you forget the password, you will have to use your Roku remote to repeat the button pattern to enable developer mode (home, home, home, up, up, right, left, right, left, right)

### deploy app
 - On a Windows PC, press F5
 - On MacOS, press Fn + F5
 - The ZIP file will be automatically generated in /out/roku-deploy.zip and then automatically deployed to your Roku device

### console and debugging
 - The OUTPUT and DEBUG CONSOLE windows inside vscode will show your app activity and print commands
 - Enabling "showDeviceInfo" or "showAppInfo" at the top of the Main.brs file will print information about the device to the console
 - The console/debug session will automatically close when exiting the app

### screens
The /components/screens/LandingScreen is a sample file and is not necessary for deployment. This is added only as a visual representation that the app has successfully been deployed.

### globals
 - At the bottom of the /source/Main.brs file, under setGlobals(), there are key/value samples which are assigned to the m.global object. The "os", "internet", and "model" are used inside of /components/data/requirements.json to represent requirements for opening and using the app (minimum RokuOS version, internet connectivity, and model number of the Roku).
 - The app requirements are turned off by default "setRequirements(false)" at the top of /components/HomeScene.brs. Change to "setRequirements(true)", if you want to test the requirements feature. Additional requirements can be added to the json file as long as the key values match the ones set in m.global.*
 - m.global values can be accessed from anywhere in the app by accessing m.global.* 

### themes
The /components/utils/Themes.brs file utilizes a json data file located at /components/data/themes.json. This json data represents a central theme for various colors throughout the app. This includes the pallete for the scene node which dictates the color for dialogs, keyboards, pin pads, as well as background colors/images. A selectorUri is also available for creating custom 9-patch selectors in rowlists.

### translations
The /locale folder contains sample folders and files for translating to French, Italian, and German languages. You can modify the translations.xml file to associate any string that uses tr("string to translate") from anywhere in the app. Additional languages can be added using the same folder and file structure.

### messages
The /components/utils/Messages.brs file utilizes a json data file located at /components/data/messages.json. This json data represents a message object that is activated by setting the message string interface on the top level node (HomeScene). If the message string matches the key in the json file, a modal/pop-up will appear in the UI for user interaction. Additional key/values can be added to the messages.json for representing both error and notification messages.

### focus
Roku uses the term "focus" to define which node is assigned key events from the remote control. The HomeScene uses a top level interface called "focusedNode" which takes in a node as a placeholder. This allows other screens such as the Dialog Modal to easily return focus to the previous node. This can also be used when pressing the back button to set focus to a specific node on the previous screen. An example of this is used inside the screenVisible() function at /componenents/screens/landing/LandingScreen.brs

### history
To create a new node/screen and add it as a child of HomeScene.xml, use the setScreen("screenName", "screenId") function from /components/utils/Screens.brs. You can see this function being used to create the Landing Screen inside the startApp() function of HomeScene.brs. If the 2nd argument is ommitted (screenId) from the function arguments, the screenName (1st argument) will be assigned as the node ID.

There are 3 additional arguments that can be used with setScreen() - showScreen, hidePrevScreen, and addToStack. All are set to true by default. 
- showScreen as false will prevent the newly created node from appearing on the screen.
- hidePrevScreen as false will prevent the current screen from being hidden.
- addToStack as false will prevent the newly created screen from being added to history.

To find an existing node screen (existing child of HomeScene.xml), use the getScreen("screenId") function. There is a 2nd argument (showScreen) regarding the visibility of the node which is set to false by default. Setting the argument to true will make the node immediately visible.

To remove a node as a child of HomeScene, use the deleteScreen() function. There are 3 total arguments:
 - The 1st argument can be either the node itself (roSGNode) or the id (string) of the node to be removed.
 - The 2nd argument (showPrevScreen) defaults to true for showing the previous screen if hidden.
 - The 3rd argument (removeFromStack) defaults to true for removing the node from the history stack.

To create, remove, and find nodes/screens from a BRS file, the associated xml file requires a top level script - "pkg:/components/utils/Screens.brs" (see LandingScreen.xml). You will need to add this script entry to any XML file that uses the functions mentioned above.