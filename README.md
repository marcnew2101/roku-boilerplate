# roku-boilerplate
A basic starting point for creating new Roku/Brightscript projects. This project is in no way affiliated with Roku Inc. or its subsidaries.

## requirements
 - A Roku device with developer mode enabled (https://developer.roku.com/docs/developer-program/getting-started/developer-setup.md).
The Roku must share the same network/subnet as the computer you are using to develop the app.
 - A web browser.

## not required
An understanding of the Roku language and framework. Docs are here for reference - https://developer.roku.com/docs/references/references-overview.md
While the Roku developer community is not as large as other programming languages, there are a multitude of sample files developed by the community here - https://github.com/rokudev/samples

## plugins
This project makes use of the vscode-brightscript-language plugin. It can be added through the extensions library in vscode or from the marketplace at https://marketplace.visualstudio.com/items?itemName=RokuCommunity.brightscript

## structure
The ".vscode/launch.json" file at the root of the project contains definitions for handling the folder structure and deployment of your app. If you create additional folders for your project, you must update the launch.json file ("files": [".."]) so that the new folders are included in the deployment.

## pre-deployment
Begin by renaming the ".env_sample" file to ".env". This file is located at the root of the project folder.
Replace "ROKU_HOST" with the IP address of your Roku device. The IP address can be found in the Roku onscreen menu at "Settings -> Network -> About".
Replace "ROKU_PASSWORD" with the password you created when you first enabled developer mode on your Roku device. If you forget the password, you will have to use your Roku remote to enter the same button pattern to enable developer mode (home, home, home, up, up, right, left, right, left, right).

## start app
On a Windows PC, press F5
On MacOS, press Fn + F5

## console and debugging
The OUTPUT and DEBUG CONSOLE windows in vscode will show your app activity. Enabling "showDeviceInfo" at the top of the Main.brs file will present an example of printing to the console.