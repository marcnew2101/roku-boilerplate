# roku-boilerplate
A basic starting point for creating new Roku/Brightscript projects. This project is in no way affiliated with Roku Inc. or its subsidaries.

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
The ".vscode/launch.json" file at the root of the project contains definitions for handling the folder structure and deployment of your app. If you create additional folders for your project, you must update the launch.json file ("files": [".."]) so that the new folders are included in the deployment.

### pre-deployment
 - Begin by renaming the ".env_sample" file to ".env". This file is located at the root of the project folder
 - Replace "ROKU_HOST" with the IP address of your Roku device. The IP address can be found in the Roku onscreen menu at:  Settings -> Network -> About
 - Replace "ROKU_PASSWORD" with the password you created when you first enabled developer mode on your Roku device. If you forget the password, you will have to use your Roku remote to enter the same button pattern to enable developer mode (home, home, home, up, up, right, left, right, left, right)

### deploy app
 - On a Windows PC, press F5
 - On MacOS, press Fn + F5
 - The ZIP file will be automatically generated in /out/roku-deploy.zip and then automatically deployed to your Roku device

### console and debugging
 - The OUTPUT and DEBUG CONSOLE windows inside vscode will show your app activity and print commands, once deployed
 - Enabling "showDeviceInfo" or "showAppInfo" at the top of the Main.brs file will present you with an example of printing to the console
 - The console session will automatically close when exiting the app

### screens
The /components/screens/LandingScreen is a sample file and is not necessary for deployment. This is added only as a visual representation that the app has successfully been deployed.

### globals
 - The /source/Main.brs file includes 6 key/value examples, located under setGlobals() at bottom. The "os", "internet", and "model" are assigned to the m.global object key/values. Each of these are used inside of /components/utils/Requirements.brs to represent conditional requirements for opening the app (RokuOS version, internet connectivity, model number of Roku device)
 - The app requirements are turned off by default "startApp(setRequirements(false))" at the top of /components/HomeScene.brs. Change to "startApp(setRequirements(true))", if you want to test the requirements feature.
 - The values inside of the m.global object can be accessed from anywhere in the app using m.global."key". 

### translations
The /locale folder contains sample folders and files for translating English to French, Italian, and German languages. You can modify the translations.xml file to associate any string that uses tr("string to translate") from anywhere in the app. Additional languages can be added using the same folder(language) and file(translations.xml) structure.

### errors
The /components/utils/Errors.brs file utilizes a json data file located at /components/data/errors.json. This will show an error message modal in the UI for user notifications and feedback. Additional key/values can be added to errors.json for producing other error messages in the app.